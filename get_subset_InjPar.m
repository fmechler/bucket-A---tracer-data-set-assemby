function  InjPar1=get_subset_InjPar(InjPar,ii_subset)
%
%% function  InjPar1=get_subset_InjPar(InjPar,ii_subset)
%
% Returns specific subset of the InjPar 
           InjPar1.brnID=InjPar.brnID(ii_subset);
            InjPar1.Ainj=InjPar.Ainj(ii_subset);
            InjPar1.Tinj=InjPar.Tinj(ii_subset);
     InjPar1.isFinalized=InjPar.isFinalized(ii_subset);
    InjPar1.isRegistered=InjPar.isRegistered(ii_subset);
        InjPar1.onPortal=InjPar.onPortal(ii_subset);
        InjPar1.reInject=InjPar.reInject(ii_subset);
           InjPar1.tr_id=InjPar.tr_id(ii_subset);
            InjPar1.trcr=InjPar.trcr(ii_subset);
          InjPar1.ara_id=InjPar.ara_id(ii_subset);
               InjPar1.x=InjPar.x(ii_subset);
               InjPar1.y=InjPar.y(ii_subset);
               InjPar1.z=InjPar.z(ii_subset);