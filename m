Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab3CDPOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:14:30 -0500
Message-ID: <1362410065.21028.19.camel@jlt4.sipsolutions.net> (sfid-20130304_161434_032569_6C8AF166)
Subject: Re: [PATCH v2 0/7] mac80211: improve and consolidate minstrel rate
 control
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Date: Mon, 04 Mar 2013 16:14:25 +0100
In-Reply-To: <1362406937-69969-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362406937-69969-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 15:22 +0100, Thomas Huehn wrote:
> This patch series merges functions, macros and sampling improvements from
> minstrel_ht into minstrel. It adds several improvements to the rate control.  

While this compiles, sparse is very unhappy:

net/mac80211/rc80211_minstrel.c:386:18: error: bad constant expression
net/mac80211/rc80211_minstrel.c:394:47: error: cannot size expression

I'd definitely prefer sparse to not error on this code (I can live with
warnings) so it remains useful.

johannes

