Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:3494 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0DYW5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 18:57:36 -0400
Subject: Re: wl1251_sdio PSM
From: GNUtoo <GNUtoo@no-log.org>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1272232671.2349.25.camel@gnutoo-desktop>
References: <1272230300.2349.23.camel@gnutoo-desktop>
	 <1272232671.2349.25.camel@gnutoo-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 00:47:12 +0200
Message-ID: <1272235632.2349.28.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I changed added | IEEE80211_HW_SUPPORTS_PS in:
> wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
>                 IEEE80211_HW_NOISE_DBM;
> 
> Denis.
that was the wrong fix.
The good fix(many thanks to chr_ in #linux-wireless) was to try
compat-wireless,which bringed many more power saving features according
to him.

Denis.



