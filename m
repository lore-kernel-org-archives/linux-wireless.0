Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:55713 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1AAOvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:51:12 -0500
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 1/6] ath5k: Always write tx powertable on hw
Date: Sat, 1 Jan 2011 23:51:07 +0900
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	nbd@openwrt.org, sedat.dilek@googlemail.com
References: <20101203040300.GA2988@makis.mantri> <AANLkTinD+XrkXeUR2PNqj4eVVvTmrh8a9c4UEy0Nr7JE@mail.gmail.com>
In-Reply-To: <AANLkTinD+XrkXeUR2PNqj4eVVvTmrh8a9c4UEy0Nr7JE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101012351.07339.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 30 December 2010 06:02:29 Bob Copeland wrote:
> On Thu, Dec 2, 2010 at 11:03 PM, Nick Kossifidis <mickflemm@gmail.com> 
wrote:
> >  * By skipping tx power table calibration we also skip setting
> >  tx power table on hw. Make sure we always write tx power table
> >  on hw since it gets cleared on reset.
> > 
> >  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> Just a very late heads-up, this patch seems to be causing problems
> for me.
> 
> Seems a bit weird given the content, but the symptom is that
> when I bring up the device none of my probe requests are actually
> getting sent, according to wireshark captures from another device.
> Reverting just this patch helps, so my power table must be broken
> at start up.
> 
> I saw that Bruno had a later series that touched this area, so I'll
> try them next.

Yep, they should fix that problem. Please try them and report if they don't.

Bruno
