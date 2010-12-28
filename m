Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:34735 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751588Ab0L1Jjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:39:44 -0500
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0360609181
	for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 18:39:42 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for 802.11j
Date: Tue, 28 Dec 2010 18:39:44 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6> <1293527282.3526.2.camel@jlt3.sipsolutions.net> <20101228092510.GA22967@jm.kir.nu>
In-Reply-To: <20101228092510.GA22967@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012281839.44125.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue December 28 2010 18:25:10 Jouni Malinen wrote:
> On Tue, Dec 28, 2010 at 10:08:02AM +0100, Johannes Berg wrote:
> > On Tue, 2010-12-28 at 11:01 +0200, Jouni Malinen wrote:
> > > Quite a few.. At least 4.85 GHz and 3.0 GHz for 20 MHz channels and
> > > more for 5 and 10 MHz channels (4.9375 GHz, 4.89 GHz, 3.0025 GHz,
> > > 4.0025 GHz, 5.0025 GHz) in channels defined by IEEE 802.11.
> > 
> > That's what I kinda thought ... doesn't that mean this patch is
> > insufficient?
> 
> Depends on what it is trying to achieve. Based on the Subject: line, it
> aims to add support for channels defined in 802.11j and it does indeed
> seem to do that (most of those odd channel starting frequencies come
> from 802.11y). If the goal were to cover all channels defined in the
> current IEEE 802.11 standard, then sure, it would be insufficient, but
> it is not like we support 3.6 GHz band or sub-20 MHz channels anyway, so
> only the 4.85 GHz starting frequency for some emergency channels from
> 802.11y would not be covered.

Well, yeah, I'm was only concerned about the 802.11j part. And I left out all 
stuff for non 20MHz channels. If it's needed these functions can be extended 
more later... The Japanese need 802.11j now, not a theoretically complete 
channel to frequency mapping... ;)

bruno
