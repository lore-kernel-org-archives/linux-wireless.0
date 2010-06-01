Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:28840 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753232Ab0FADzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 23:55:17 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0575824512
	for <linux-wireless@vger.kernel.org>; Tue,  1 Jun 2010 12:55:13 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: me@bobcopeland.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Peter Chubb <peter.chubb@nicta.com.au>
Subject: Re: Commit 6b5d,.. breaks ath5k in WPA-enabled networks
Date: Tue, 1 Jun 2010 12:55:43 +0900
References: <w47hmkh1b4.wl%peter@chubb.wattle.id.au> <w4mxvg2tz0.wl%peter@chubb.wattle.id.au> <20100531125640.GA11680@hash.localnet>
In-Reply-To: <20100531125640.GA11680@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006011255.43905.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 31 May 2010 21:56:40 you wrote:
> On Mon, May 31, 2010 at 09:25:55PM +1000, Peter Chubb wrote:
> > Bruno> On Monday 31 May 2010 18:23:43 Peter Chubb wrote:
> > >> With Linus's current head-of-tree my ath5k cannot associate with
> > >> WPA-enabled access points.  I bisected back to this patch:
> > >> 
> > >> Since commit 6b5d117eddc09cd976ad8030d715f4350f598a22 ath5k: clean
> > >> up queue manipulation
> > 
> > Bruno> try this, please:
> > Bruno> https://patchwork.kernel.org/patch/100681/
> > 
> > This works, thanks.
> 
> Yeah, big oops. :\
> 
> So what do we do now?  I guess we should just revert it for now rather
> than taking the half that works plus Bruno's fix?

cc: stable for my patch?
john?

bruno
