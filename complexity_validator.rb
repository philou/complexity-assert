
# Generates a sample of execution timings to compute the RMSE of complexity models, in order to valide them
class ComplexityValidator

  def initialize(sampler, complexity_models)
    @sampler = sampler
    @complexity_models = complexity_models
  end

  def rmses
    data = @sampler.run([8,10,12,80,100,120,800,1000,1200],10)

    @complexity_models.map do |model|
      Math.sqrt(data.map { |size, real_time|
                  (real_time - model.predict_run_time(size))**2
                }.reduce &:+)
    end
  end

end
