Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37327 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab1ISSae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 14:30:34 -0400
Message-ID: <4E778A48.4020800@openwrt.org> (sfid-20110919_203044_871821_0CC769F5)
Date: Mon, 19 Sep 2011 20:30:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH v2 2/4] ath9k_hw: clean up tx power handling
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org> <1316453903-75710-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1316453903-75710-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-19 7:38 PM, Felix Fietkau wrote:
> The code for handling various restrictions concerning regulatory limits,
> antenna gain, etc. is very convoluted and duplicated across various
> EEPROM parsing implementations, making it hard to review.
>
> This patch partially cleans up the mess by unifying regulatory limit
> handling in one function and removing dead code for transmit power scaling.
> It also simplifies handling of antenna gain
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
Hmm, don't merge this just yet, seems that there are still some issues 
with tx power limits on some devices. Will send a v3 when I've confirmed 
the fix.

- Felix
