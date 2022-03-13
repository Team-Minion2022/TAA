using System;
using System.Collections.Generic;
using System.Text;

namespace AnimalAdoption.Common.Logic
{
    public class AnimalService
    {
        public Animal[] ListAnimals => new Animal[] {
            new Animal { Id = 1, Name = "Minion 1", Age = 50, Description = "Minion 1" },
            new Animal { Id = 2, Name = "Minion 2", Age = 50, Description = "Minion 2" },
            new Animal { Id = 3, Name = "Minion 3", Age = 50, Description = "Minion 3" },
        };
    }
}
