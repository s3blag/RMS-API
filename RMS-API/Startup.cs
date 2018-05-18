using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using RMS_API.Data.Repositories;
using RMS_API.Data;

namespace RMS_API
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSingleton(c => Configuration);

            services.AddScoped<IUnitOfWork, UnitOfWork>();
            services.AddScoped<ITrainRepository, TrainRepository>();
            services.AddScoped<ICourseRepository, CourseRepository>();
            services.AddScoped<IReservationRepository, ReservationRepository>();
            services.AddScoped<IVisitRepository, VisitRepository>();

            services.AddMvc(setupAction =>
            {
                setupAction.ReturnHttpNotAcceptable = true;
                // not working with anonymous classes
                setupAction.OutputFormatters.Add(new XmlDataContractSerializerOutputFormatter());
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler(appBuilder =>
                {
                    appBuilder.Run(async context =>
                    {
                        context.Response.StatusCode = 500;
                        await context.Response.WriteAsync("An unexpected fault happened. Try again later.");
                    });
                });
            }

            app.UseMvc();
        }
    }
}
