function [list_acc] = ab_col(options)
    % DEMO for testing MEDA on MNIST and USPS datasets
    str_domains = {'1', '2'};
    list_acc = [];
    mode_new = 'closed';
    for i = 1 : 2
        src = str_domains{i};
        tar = num2str(3 - i);

        load(['data/COL20/COIL_' src '.mat']);     

        % source domain
        X_src = X_src ./ repmat(sum(X_src, 1), size(X_src,1),1);
        Xs = zscore(X_src, 1); clear X_src
        Ys = Y_src;            clear Y_src

        % target domain
        X_tar = X_tar ./ repmat(sum(X_tar, 1), size(X_tar,1),1);
        Xt = zscore(X_tar, 1); clear X_tar
        Yt = Y_tar;            clear Y_tar

        % meda
        switch mode_new
            case 'closed'
                [Acc,~,~,~] = MK_MMCD(Xs',Ys,Xt',Yt,options,mode_new,src,tar);
            case 'adam'
                options.d = 20;
                options.rho = 0.1;
                options.p = 10;
                options.lambda = 90.0;
                options.eta = 0.05;
                options.T = 100;
                options.gamma = 0.1;
                options.mu = 0.6;
                options.delta = 0.01;
                options.add = 0.01;
            %     [Acc,~,~,~] = MEDA(Xs',Ys,Xt',Yt,options);
                [Acc,~,~,~] = MK_MMCD_sgd(Xs',Ys,Xt',Yt,options,mode_new,src,tar);
        end
        fprintf('COIL_%s -> %s :%.2f accuracy \n\n', src, tar,Acc * 100);
        list_acc = [list_acc; Acc];
    end
end