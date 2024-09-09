# Moved to TaijaParallel:
Base.@deprecate_moved ProcessStyle "TaijaParallel" false
Base.@deprecate_moved NotParallel "TaijaParallel" false
Base.@deprecate_moved IsParallel "TaijaParallel" false
Base.@deprecate_moved parallelizable "TaijaParallel" false

# Moved to EnergySamplers:
Base.@deprecate_moved AbstractSampler "EnergySamplers" false
Base.@deprecate_moved AbstractSamplingRule "EnergySamplers" false
Base.@deprecate_moved ConditionalSampler "EnergySamplers" false
Base.@deprecate_moved UnconditionalSampler "EnergySamplers" false
Base.@deprecate_moved JointSampler "EnergySamplers" false
Base.@deprecate_moved PMC "EnergySamplers" false
Base.@deprecate_moved energy "EnergySamplers" false