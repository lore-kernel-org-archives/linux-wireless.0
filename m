Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:37145 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756124Ab0JFCuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 22:50:51 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0456603450
	for <linux-wireless@vger.kernel.org>; Wed,  6 Oct 2010 11:50:50 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 5/5] ath5k: Add busy ratios to survey data
Date: Wed, 6 Oct 2010 11:50:52 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, vasanth@atheros.com,
	linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
References: <20101005095510.3083.46174.stgit@tt-desk> <201010061125.54247.br1@einfach.org> <4CABE2DA.5020204@openwrt.org>
In-Reply-To: <4CABE2DA.5020204@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010061150.52352.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 6 2010 11:45:46 Felix Fietkau wrote:
> On 2010-10-06 4:25 AM, Bruno Randolf wrote:
> > On Wed October 6 2010 07:38:34 Luis R. Rodriguez wrote:
> >> This is all being sucked out of common, so can we just share the
> >> filler for the survey between ath5k and ath9k? Note we should split up
> >> hw code and core driver code on the ath module by file.
> > 
> > sure, that would be good! noise floor comes from ath5k_hw though, but
> > that can easily be moved to common.
> > 
> > there's so much code which could be shared between ath5k and ath9k...
> 
> That would need sharing of the channel list and some per-channel data
> though - so it may need some more code reshuffling...

also - we would need a common way to get ath_common from ieee80211_hw, which 
works for both ath5k and ath9k. right now each has it's own structures. so... 
i'd say: later...

bruno
