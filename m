Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59744 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3JZUyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Oct 2013 16:54:10 -0400
Received: by mail-lb0-f180.google.com with SMTP id y6so1708227lbh.25
        for <linux-wireless@vger.kernel.org>; Sat, 26 Oct 2013 13:54:09 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 27 Oct 2013 02:24:09 +0530
Message-ID: <CA+fH8T-QQKzhH4yHv1wqg5f0PXqYAg3amXctQOCG8zwqrDEM1w@mail.gmail.com> (sfid-20131026_225418_700735_99758F4A)
Subject: BRCM 4324 Help
From: Hiemanshu Sharma <hiemanshu@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

Trying to follow the instructions at
http://wireless.kernel.org/en/users/Drivers/brcm80211 I need a
brcmfmac-sdio.txt with the nvram values but I am not able to find out
where to get the file from. I've tried google a lot but there doesn't
seem to be a lot of help out there.

dmesg says :

brcmfam: brcmf_sdbrcm_download_nvram : Fail to request nvram -2
brcmfmac: _brcmf_sdbrcm_download_firmware: dongle nvram file download failed


I've used firmware from the git, and the message for missing firmware
is not shown anymore.

Regards,

Hiemanshu Sharma.
