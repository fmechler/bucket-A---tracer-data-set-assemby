function InjPar = mergeInjPar(InjPar1, InjPar2)

               
InjPar.brnID = {InjPar1.brnID{:}, InjPar2.brnID{:}};

InjPar.Ainj = [InjPar1.Ainj, InjPar2.Ainj];
InjPar.Tinj = [InjPar1.Tinj, InjPar2.Tinj];
InjPar.isFinalized = [InjPar1.isFinalized, InjPar2.isFinalized];
InjPar.isRegistered = [InjPar1.isRegistered, InjPar2.isRegistered];
InjPar.onPortal = [InjPar1.onPortal, InjPar2.onPortal];
InjPar.reInject = [InjPar1.reInject, InjPar2.reInject];
InjPar.tr_id = [InjPar1.tr_id, InjPar2.tr_id];

InjPar.trcr = {InjPar1.trcr{:}, InjPar2.trcr{:}};
InjPar.ara_id = {InjPar1.ara_id{:}, InjPar2.ara_id{:}};

InjPar.x = [InjPar1.x, InjPar2.x];
InjPar.y = [InjPar1.y, InjPar2.y];
InjPar.z = [InjPar1.z, InjPar2.z];

%% Reminder of the records in InjPar
%
%InjPar = 
%
%           brnID: {1x508 cell}
%            Ainj: [1x508 double]
%            Tinj: [1x508 double]
%     isFinalized: [1x508 logical]
%    isRegistered: [1x508 logical]
%        onPortal: [1x508 logical]
%        reInject: [1x508 logical]
%           tr_id: [1x508 double]
%            trcr: {1x508 cell}
%          ara_id: {1x508 cell}
%               x: [1x508 double]
%               y: [1x508 double]
%               z: [1x508 double]
%%