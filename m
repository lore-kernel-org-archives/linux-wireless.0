Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:2892 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754970Ab0FOBHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 21:07:32 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-070754049
	for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 10:07:30 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while resetting
Date: Tue, 15 Jun 2010 10:07:21 +0900
References: <20100611101221.26538.46913.stgit@tt-desk> <201006141050.59607.br1@einfach.org> <20100614114302.GA15017@hash.localnet>
In-Reply-To: <20100614114302.GA15017@hash.localnet>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006151007.21708.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon June 14 2010 20:43:02 you wrote:
> On Mon, Jun 14, 2010 at 10:50:59AM +0900, Bruno Randolf wrote:
> > we disable interrupts right after disabling the tasklets, so they should
> > not be scheduled again, right? actually, we should disable interrupts
> > first, and then disable tasklets... but then it should be safe, no?
> 
> Disable interrupts then tasklet_kill should do it.

what's wrong with first disable interrupts and tasklet_disable?

bruno
