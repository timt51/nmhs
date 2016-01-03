function flattened_model = flatten3DModel(packed_3D_model)
  [tr1, tr2, tr3, em1, em2, em3] = unpack3DHMM(packed_3D_model);
  tr1_flat = flatten3DTR(tr1);
  tr2_flat = flatten3DTR(tr2);
  tr3_flat = flatten3DTR(tr3);

  flattened_model = pack3DHMM(tr1_flat,tr2_flat,tr3_flat,em1,em2,em3);
end


function tr_flat = flatten3DTR(tr)
  flat = mean(mean(tr, 4), 3);
  flat = bsxfun(@rdivide, flat, sum(flat, 1));
  for i=1:size(tr, 3)
      for j = 1:size(tr,4)
          tr_flat(:,:,i,j) = flat;
      end
  end
end
