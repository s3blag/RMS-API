﻿using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using RMS_API.Data.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace RMS_API.Data.Repositories
{
    public class TrainRepository : BaseRepository<TrainRepository>, ITrainRepository
    {
        public TrainRepository(IConfiguration config, ILogger<TrainRepository> logger) : base(config, logger)
        { }

        public IEnumerable<TrainDto> GetAll()
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"SELECT * FROM Show_Trains", sqlConnection))
                {
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return null;

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new TrainDto
                {
                    Id = Convert.ToInt32(row[0]),
                    Name = row[1] as string,
                    Model = row[2] as string
                });

                return result;
            }
            catch(Exception ex)
            {   
                if(ex is InvalidCastException)
                    logger.LogError($"ID is not an integer: {ex}");
                else
                    logger.LogError($"DB Connection Error: {ex}");
                throw;
            }
        }

        public TrainDto GetById(int id)
        {
            try
            {
                DataTable dataTable;
                int count;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlDataAdapter = new SqlDataAdapter($"SELECT * FROM SHOW_TRAINS WHERE train_id = @id", sqlConnection))
                {
                    var sqlCommand = sqlDataAdapter.SelectCommand;
                    sqlCommand.Parameters.AddWithValue("@id", id);
                    dataTable = new DataTable();
                    count = sqlDataAdapter.Fill(dataTable);
                }

                if (count == 0)
                    return null;

                var result = dataTable.Rows.Cast<DataRow>().Select(row => new TrainDto
                {
                    Id = Convert.ToInt32(row[0]),
                    Name = row[1] as string,
                    Model = row[2] as string
                }).First();

                return result;
            }
            catch (Exception ex)
            {
                if (ex is InvalidCastException)
                    logger.LogError($"ID is not an integer: {ex}");
                else
                    logger.LogError($"DB Connection Error: {ex}");
                throw;
            }
        }

        public int Add(TrainForCreationDto train)
        {
            try
            {
                int newId = -1;

                using (var sqlConnection = new SqlConnection(sqlConnectionString))
                using (var sqlCommand = new SqlCommand($"EXEC ADD_TRAIN @name, @model", sqlConnection))
                {
                    var returnParameter = sqlCommand.Parameters.Add("@result", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.Output;
                    
                    sqlCommand.Parameters.AddWithValue("@name", train.Name);
                    sqlCommand.Parameters.AddWithValue("@model", train.Model);
                    sqlConnection.Open();
                    var result = sqlCommand.ExecuteScalar();

                    newId = Convert.ToInt32(result);

                }

                return newId;

            }
            catch(Exception ex)
            {
                logger.LogInformation($"AddTrain DB Connection Error: {ex}");
                return -1;
            }
        }
    }
    
}
