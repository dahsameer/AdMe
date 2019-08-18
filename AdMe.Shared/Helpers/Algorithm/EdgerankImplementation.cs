using AdMe.Model.Post;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace AdMe.Shared.Helpers.Algorithm
{
    public static class EdgerankImplementation
    {
        public static List<PostAlgorithmModel> SortPost(List<PostAlgorithmModel> posts, List<string> allKeywords)
        {
            List<string> keywords = new List<string>();
            foreach(var spkeywords in allKeywords)
            {
                var arr = spkeywords.Split(",");
                keywords.AddRange(arr);
            }

            keywords = keywords.GroupBy(x => x)
                .OrderByDescending(x => x.Count())
                .Select(g => g.Key)
                .Take(20).ToList();

            for(int i=0; i<posts.Count; i++)
            {
                //Calculating the percentage similarity or epsilon
                double PercentageSimilarity = 0;
                var postkeywordsarray = posts[i].PostKeywords.Split(",");
                foreach(var akw in postkeywordsarray)
                {
                    if (keywords.Contains(akw))
                    {
                        PercentageSimilarity += 0.5;
                    }
                }
                posts[i].Epsilon = PercentageSimilarity;
                //finished calculation of percentage matches

                posts[i].Gamma = (posts[i].AffinityScore + posts[i].Epsilon) / 2;

                DateTime currentTime = DateTime.Now;
                if ((currentTime - posts[i].PostedTime).TotalSeconds <= 60)
                {
                    posts[i].TimeDecay = 1.5;
                }
                else if((currentTime - posts[i].PostedTime).TotalMinutes>1 && (currentTime - posts[i].PostedTime).TotalMinutes <= 10)
                {
                    posts[i].TimeDecay = 1.45;
                }
                else if((currentTime - posts[i].PostedTime).TotalMinutes > 10 && (currentTime - posts[i].PostedTime).TotalMinutes <= 60)
                {
                    posts[i].TimeDecay = 1.4;
                }
                else if((currentTime - posts[i].PostedTime).TotalHours > 1 && (currentTime - posts[i].PostedTime).TotalHours <= 6)
                {
                    posts[i].TimeDecay = 1.35;
                }
                else if((currentTime - posts[i].PostedTime).TotalHours > 6 && (currentTime - posts[i].PostedTime).TotalHours <= 24)
                {
                    posts[i].TimeDecay = 1.2;
                }
                else if((currentTime - posts[i].PostedTime).TotalDays > 1 && (currentTime - posts[i].PostedTime).TotalDays <= 7)
                {
                    posts[i].TimeDecay = 1.05;
                }
                else
                {
                    posts[i].TimeDecay = 1;
                }

                posts[i].PostWeight = posts[i].Gamma * posts[i].TimeDecay;
                if (posts[i].Interacted)//decrease postweight if user already interacted on it or if 
                {
                    posts[i].PostWeight = posts[i].PostWeight / 2;
                }
            }
            posts = posts.OrderByDescending(x => x.PostWeight).ToList();
            return posts;
        }

        public static string[] keywordsExtraction(string content)
        {
            List<string> words = content.Split(" ").ToList();
            var onlyAlphabetRegEx = new Regex(@"^[A-z]+$"); //using regular expression to remove any non alphabet strings from the words
            words = words.Where(f => onlyAlphabetRegEx.IsMatch(f)).ToList();
            content = content.ToLower();
            string[] nonwords;
            string[] keywords;
            using (StreamReader sr = new StreamReader("fillers.csv"))
            {
                String line = sr.ReadToEnd();
                nonwords = line.Split(',');
            }
            keywords = words.Where(x => !nonwords.Contains(x)).ToList().ToArray<string>();
            if(keywords.Length < 1)
            {
                keywords = new List<string> { "" }.ToArray<string>();
            }
            return keywords;
        }
    }
}
