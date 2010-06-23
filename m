Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0FWIZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 04:25:16 -0400
Subject: Re: [PATCH 1/3] Libertas: cfg80211 support
From: Johannes Berg <johannes@sipsolutions.net>
To: dkiran@marvell.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1276533086.18884.9.camel@pe-lt028>
References: <1276533086.18884.9.camel@pe-lt028>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 10:25:56 +0200
Message-ID: <1277281556.3642.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-14 at 22:01 +0530, Kiran Divekar wrote:
> Holger Schurig's patch (https://patchwork.kernel.org/patch/64286/)
> is rebased to latest wireless-testing tree.


+drivers/net/wireless/libertas/cfg.c:1844:13: warning: incorrect type in assignment (different base types)
+drivers/net/wireless/libertas/cfg.c:1844:13:    expected unsigned short [unsigned] [usertype] capability
+drivers/net/wireless/libertas/cfg.c:1844:13:    got restricted __le16 [usertype] <noident>
+drivers/net/wireless/libertas/cmdresp.c:106:5: warning: symbol 'lbs_ret_802_11d_domain_info' was not declared. Should it be static?

I'm guessing this patchset is at fault.

johannes

