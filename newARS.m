function [ score_ARS ] = newARS( imageorg,salorg,allpath)

 set_num=1;op_num=1;SET_NUM=1;OP_NUM=1;C1 = 1e-6; 
 im_org=imageorg;
%  im_ret=J;
%  [foo_XX, foo_YY] = BWRegistration(im_org, im_ret);
%   All_XX{set_num,op_num} = foo_XX;
%         All_YY{set_num,op_num} = foo_YY;
%  
 smap=salorg;
 BLK_SIZE = 16;
 ALPHA = 0.30;
 
 All_BLK_changes = cell(SET_NUM,OP_NUM);
All_BLK_sal = cell(SET_NUM,1);
 [height_org, width_org,~] = size(im_org);
    blk_h = floor(height_org/BLK_SIZE); blk_w = floor(width_org/BLK_SIZE);    
    blk_sal_org = zeros(blk_h, blk_w);
    smap = smap/sum(smap(:));
    for bi = 1:blk_h
        for bj = 1:blk_w
            top_h = (bi-1)*BLK_SIZE+1; top_w = (bj-1)*BLK_SIZE+1;
            CBlock_sal = smap(top_h:(top_h+BLK_SIZE-1), ...
                top_w:(top_w+BLK_SIZE-1));
            blk_sal_org(bi, bj) = sum(sum(CBlock_sal));
        end
    end
    All_BLK_sal{set_num} = blk_sal_org;     

%     XX = All_XX{set_num, op_num}; YY = All_YY{set_num, op_num};
        [Func_aprox_X,   Func_aprox_Y] = newregistration(imageorg,allpath);    %func_approx_X��
        Block_change_info = ReTransBLK(im_org, Func_aprox_X, Func_aprox_Y, BLK_SIZE);
        All_BLK_changes{set_num, op_num} = Block_change_info;      

 
   CBlock_sal_org = All_BLK_sal{set_num};      
    [blk_h, blk_w] = size(CBlock_sal_org);       
    ARS = zeros(blk_h, blk_w);                 
    
        CBlock_change_info = All_BLK_changes{set_num, op_num};      
        CBlock_info_h = CBlock_change_info(:,:,1);
        CBlock_info_w = CBlock_change_info(:,:,2);
        % compute the distortion for each op_num
        for bi = 1:blk_h
            for bj = 1:blk_w
                w_ratio = ( CBlock_info_w(bi, bj) )/BLK_SIZE;
                h_ratio = ( CBlock_info_h(bi, bj) )/BLK_SIZE;
                m_ratio = (w_ratio + h_ratio)/2;
                ARS(bi, bj) = exp( -ALPHA*(m_ratio-1).^2)*...
                                (2*w_ratio*h_ratio+C1)/(w_ratio^2+h_ratio^2+C1);
            end
        end  
        foo_score = CBlock_sal_org.*ARS;
        score_ARS =sum(foo_score(:));
%         l=1;
    end    



