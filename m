Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:49842 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754916Ab0IQChU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:37:20 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0297121039
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:37:19 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: reorder base.c to remove fwd decls
Date: Fri, 17 Sep 2010 11:37:41 +0900
Cc: "John W. Linville" <linville@tuxdriver.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
References: <1284231996-29010-1-git-send-email-me@bobcopeland.com> <20100916193652.GE7221@tuxdriver.com> <20100916231846.GA28873@hash.localnet>
In-Reply-To: <20100916231846.GA28873@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009171137.41794.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri September 17 2010 08:18:46 Bob Copeland wrote:
> On Thu, Sep 16, 2010 at 03:36:52PM -0400, John W. Linville wrote:
> > > Worth the churn?  Is there any way to do this kind of patch that
> > > doesn't suck?
> > 
> > Apparently not...
> > 
> > Well, I hate to ask for a rebase -- but this doesn't apply anymore!
> > I would just fix it up, but that offending hunk is 2500 lines or so...
> 
> (for Bruno's benefit since I said as much on irc) -- I'll redo this
> one as soon as the crypto series is pushed out in w-t.

just in case you missed it - i have rebased it and sent it out in my last 
series.

bruno
