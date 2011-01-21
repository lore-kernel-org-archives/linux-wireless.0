Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21294 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab1AUGei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 01:34:38 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 22:34:19 -0800
Date: Fri, 21 Jan 2011 12:03:53 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/WIP 15/33] ath9k_htc: Add ANI for AP mode
Message-ID: <20110121063353.GB20058@vasanth-laptop>
References: <19768.63236.977078.2280@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19768.63236.977078.2280@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 21, 2011 at 08:31:24AM +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> +	if (priv->ah->opmode == NL80211_IFTYPE_AP)
> +		cancel_delayed_work_sync(&priv->ath9k_ani_work);
> +

What about ANI for other vifs?

Vasanth
