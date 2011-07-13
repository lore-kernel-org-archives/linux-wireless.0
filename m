Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1GMH3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 03:29:04 -0400
Subject: Re: [PATCH 15/24] ath6kl: add ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de, error27@gmail.com
In-Reply-To: <20110713013524.8517.92169.stgit@localhost6.localdomain6> (sfid-20110713_033533_941292_7CB29E9A)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013524.8517.92169.stgit@localhost6.localdomain6>
	 (sfid-20110713_033533_941292_7CB29E9A)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 09:29:16 +0200
Message-ID: <1310542156.3873.3.camel@jlt3.sipsolutions.net> (sfid-20110713_092908_924441_EAF5E2AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 04:35 +0300, Kalle Valo wrote:
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/ieee80211.h |  158 +++++++++++++++++++++++++++

This file shouldn't exist. Anything generic should go to
include/linux/ieee80211.h, and anything HW specific shouldn't be called
IEEE80211_*.

johannes

