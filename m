Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35217 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbKJHY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 02:24:56 -0500
Received: by pasz6 with SMTP id z6so233050958pas.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2015 23:24:55 -0800 (PST)
From: "Yin, Fengwei" <fengwei.yin@linaro.org>
To: andy.green@linaro.org, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH v2 0/5] wcn36xx: add some new firmware functionalities support
Date: Tue, 10 Nov 2015 03:25:50 -0500
Message-Id: <1447143955-10304-1-git-send-email-fengwei.yin@linaro.org> (sfid-20151110_082459_186517_73B50EB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
This patchset are from Andy Green. Which support some functionalities of
latest wcn36xx firmware.

Changelog since v1
  - decouple the connection of wcn36xx_smd_rsp_status_check_v2 with 3620.
    This also fix the build error.
  - Remove additional "From" introduced in v1.

Andy Green (5):
  wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
  wcn36xx: swallow two wcn3620 IND messages
  wcn36xx: handle new hal response format
  wcn3620: use new response format for wcn3620 trigger_ba
  wcn3620: use new response format for wcn3620 remove_bsskey

 drivers/net/wireless/ath/wcn36xx/hal.h |  2 ++
 drivers/net/wireless/ath/wcn36xx/smd.c | 27 +++++++++++++++++++++++++--
 drivers/net/wireless/ath/wcn36xx/smd.h |  9 +++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

-- 
2.1.4

