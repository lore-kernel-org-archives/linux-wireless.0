Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33090 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbbKIJBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 04:01:24 -0500
Received: by pabfh17 with SMTP id fh17so193215394pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 01:01:24 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH 0/5] wcn36xx: add some new firmware functionalities support
Date: Mon,  9 Nov 2015 05:02:37 -0500
Message-Id: <1447063362-27322-1-git-send-email-fengwei.yin@linaro.org> (sfid-20151109_100128_253909_C3285882)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset are from Andy Green. Which support to some functionalities
of latest wcn36xx firmware.

Thanks.

Andy Green (5):
  wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
  wcn36xx: swallow two wcn3620 IND messages
  wcn36xx: handle new hal response format
  wcn3620: use new response format for wcn3620 trigger_ba
  wcn3620: use new response format for wcn3620 remove_bsskey

 drivers/net/wireless/ath/wcn36xx/hal.h |  2 ++
 drivers/net/wireless/ath/wcn36xx/smd.c | 28 ++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wcn36xx/smd.h |  9 +++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

-- 
2.1.4

