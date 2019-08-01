using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdMe.Shared.Helpers.StaticData
{
    public class RandomStringGenerator
    {
        private static Random random = new Random();
        public static string GenerateString(int length=20, string type="alphanumeric")
        {
            string chars;
            switch (type)
            {
                case "alphabetic":
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    break;
                case "numeric":
                    chars = "0123456789";
                    break;
                case "alphanumeric":
                default:
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                    break;
            }
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }
    }
}
