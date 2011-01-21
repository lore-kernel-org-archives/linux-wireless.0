Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42174 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1AUGpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 01:45:47 -0500
Received: by gyb11 with SMTP id 11so436769gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 22:45:47 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19769.11112.515793.53874@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 12:14:56 +0530
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/WIP 15/33] ath9k_htc: Add ANI for AP mode
In-Reply-To: <20110121063353.GB20058@vasanth-laptop>
References: <19768.63236.977078.2280@gargle.gargle.HOWL>
	<20110121063353.GB20058@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> On Fri, Jan 21, 2011 at 08:31:24AM +0530, Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > +	if (priv->ah->opmode == NL80211_IFTYPE_AP)
> > +		cancel_delayed_work_sync(&priv->ath9k_ani_work);
> > +
> 
> What about ANI for other vifs?

I have a half-finished patch handling ANI in multi-VIF scenario, will
fold it into this.

Sujith
