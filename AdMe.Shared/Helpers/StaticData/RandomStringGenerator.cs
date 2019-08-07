using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdMe.Shared.Helpers.StaticData
{
    public class RandomStringGenerator
    {
        private static Random random = new Random();
        public enum RandomStringType
        {
            ALPHANUMERIC, NUMERIC, APHABETIC
        };

        /// <summary>
        /// 
        /// </summary>
        /// <param name="The length of the string to return"></param>
        /// <param name="typeof alpha"></param>
        /// <returns></returns>
        public static string GenerateString(int length=20, RandomStringType type = RandomStringType.ALPHANUMERIC)
        {
            string chars;
            switch (type)
            {
                case RandomStringType.APHABETIC:
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                    break;
                case RandomStringType.NUMERIC:
                    chars = "0123456789";
                    break;
                case RandomStringType.ALPHANUMERIC:
                default:
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                    break;
            }
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }
    }
}
