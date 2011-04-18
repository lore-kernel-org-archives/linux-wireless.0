Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45916 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DRLrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:47:00 -0400
Received: by pvg12 with SMTP id 12so2125354pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:47:00 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19884.9295.754943.942516@gargle.gargle.HOWL>
Date: Mon, 18 Apr 2011 17:15:19 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, jouni.malinen@atheros.com
Subject: Re: [PATCH 1/2] ath9k: fix powersave frame filtering/buffering in AP mode
In-Reply-To: <4DAC2016.3000008@openwrt.org>
References: <1303075690-53804-1-git-send-email-nbd@openwrt.org>
	<19883.48525.986878.991570@gargle.gargle.HOWL>
	<4DABFC54.8030502@openwrt.org>
	<19884.7222.186200.867910@gargle.gargle.HOWL>
	<4DAC2016.3000008@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I should probably add an extra check that tests for tid->buf_q being 
> empty - and some comments.
> This handles a race condition that occurs if an A-MPDU completes (with 
> some pending frames) after the station entered PS and 
> ieee80211_sta_set_tim was not called because the buffer queue was empty.

Alright, thanks for the explanation.

Sujith
