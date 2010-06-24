Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:41771 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0FXFiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 01:38:13 -0400
From: Kiran Divekar <dkiran@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 23 Jun 2010 22:38:10 -0700
Subject: RE: [PATCH 1/3] Libertas: cfg80211 support
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C04D64A250E@SC-VEXCH1.marvell.com>
In-Reply-To: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> On Mon, 2010-06-14 at 22:01 +0530, Kiran Divekar wrote:
> > Holger Schurig's patch (https://patchwork.kernel.org/patch/64286/)
> > is rebased to latest wireless-testing tree.

Hi Johannes, John,

> 
> 
> +drivers/net/wireless/libertas/cfg.c:1844:13: warning: incorrect type in
> assignment (different base types)
> +drivers/net/wireless/libertas/cfg.c:1844:13:    expected unsigned short
> [unsigned] [usertype] capability
> +drivers/net/wireless/libertas/cfg.c:1844:13:    got restricted __le16
> [usertype] <noident>
> +drivers/net/wireless/libertas/cmdresp.c:106:5: warning: symbol
> 'lbs_ret_802_11d_domain_info' was not declared. Should it be static?
> 

These errors did not show up during my compilation. I will now make sure to check with various kernel configs. Any other things should I test?

> I'm guessing this patchset is at fault.
> 
> Johannes

- Kiran

