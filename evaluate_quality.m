function [ssim_val, psnr_val, mean_scielab_error] = evaluate_quality(originalRGB, mosaicRGB)
    originalRGB = im2double(originalRGB);
    mosaicRGB = im2double(mosaicRGB);

    % SSIM
    ssim_val = ssim(mosaicRGB, originalRGB);

    % PSNR - PEAK SNR
    psnr_val = psnr(mosaicRGB, originalRGB);

    % S-CIELAB
    orig_XYZ = rgb2xyz(originalRGB);
    mosaic_XYZ = rgb2xyz(mosaicRGB);

    ppi = 224; d = 20; % ppi macbook m4
    sampPerDegree = ppi*d*tan(pi/180);

    wp = whitepoint('d65') / 100; 

    errorMap = scielab(sampPerDegree, orig_XYZ, mosaic_XYZ, wp, 'xyz');

    mean_scielab_error = mean(errorMap(:));
    
    % --- Optional: Visualize the S-CIELAB Error Map ---
    % figure;
    % imagesc(errorMap);
    % colorbar;
    % title('S-CIELAB Perceptual Error Map');
    % colormap('hot');
end