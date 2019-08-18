using System;
using System.Collections.Generic;
using System.Text;

namespace AdMe.Model.Post
{
    public class PostAlgorithmModel
    {
        public string PostId { get; set; }
        public string PostContent { get; set; }
        public int Poster { get; set; }
        public DateTime PostedTime { get; set; }
        public double AffinityScore { get; set; }
        public string PostKeywords { get; set; }
        public double Epsilon { get; set; }
        public double Gamma { get; set; }
        public double TimeDecay { get; set; }
        public double PostWeight { get; set; }
        public bool Interacted { get; set; }
    }

}
