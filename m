Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2G0Lw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:52:56 -0400
Message-ID: <1343389960.4449.6.camel@jlt3.sipsolutions.net> (sfid-20120727_135259_356636_8FA30528)
Subject: Re: [PATCH v6] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: Arik Nemtsov <arik@wizery.com>, nbd@openwrt.org, coelho@ti.com,
	brcm80211-dev-list@broadcom.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	ilw@linux.intel.com, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, chunkeey@googlemail.com,
	dsd@gentoo.org, buytenh@wantstofly.org
Date: Fri, 27 Jul 2012 13:52:40 +0200
In-Reply-To: <501260DB.1020606@net.t-labs.tu-berlin.de>
References: <1343318961-46933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	  <1343319453.4477.2.camel@jlt3.sipsolutions.net>
	  <1343319579.4477.3.camel@jlt3.sipsolutions.net>
	  <501170F2.3050300@net.t-labs.tu-berlin.de>
	  <CA+XVXfegYYwc=esyZmJHu1tEqQKcq+h+MnSyp9dXiiwqroG3tw@mail.gmail.com>
	  <CA+XVXfcrb9=XQauvbPzw2t_jMoQisrh5aSB1qwpLxXsKJKy2Yg@mail.gmail.com>
	  <CA+XVXfe1uomu4XYD33==bFFozbo9k4mkqC1PE1ORnvVN_1PeTg@mail.gmail.com>
	  <5011A250.4010500@net.t-labs.tu-berlin.de>
	 <1343374017.4449.0.camel@jlt3.sipsolutions.net>
	 <501260DB.1020606@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 11:35 +0200, Thomas Huehn wrote:
> Hi Johannes,
> 
> Johannes Berg schrieb:
> 
> 
> > When you do, please remove the last two hunks from your patch that are
> > spurious indentation changes in tx.c
> 
> 
> When Ariks two TI driver patches make it in your tree I will clean up
> this two hunks... no prob.

I did it myself now, all applied.

johannes

