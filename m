Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42989 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab3HGHWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:22:37 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20993.62691.924617.519070@gargle.gargle.HOWL> (sfid-20130807_092240_197406_9CD8E830)
Date: Wed, 7 Aug 2013 12:48:59 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 2/2] ath9k: Run the LNA combining algorithm properly
In-Reply-To: <5201F4B9.1080109@openwrt.org>
References: <1375858768-24655-1-git-send-email-sujith@msujith.org>
	<1375858768-24655-3-git-send-email-sujith@msujith.org>
	<5201F4B9.1080109@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> > -	struct ath_hw *ah = sc->sc_ah;
> > +	struct ath_hw *ah = sc->sc_ah
> > +;	struct ath9k_hw_capabilities *pCap = &ah->caps;
> >  	struct ath_common *common = ath9k_hw_common(ah);
> >  	struct ieee80211_hw *hw = sc->hw;
> >  	struct ieee80211_hdr *hdr;
> Misplaced semicolon

Thanks, I'll send v2.

Sujith
