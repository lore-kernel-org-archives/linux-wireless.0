Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27270 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752200Ab0JHAmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 20:42:01 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0441168517
	for <linux-wireless@vger.kernel.org>; Fri,  8 Oct 2010 09:41:59 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Date: Fri, 8 Oct 2010 09:42:02 +0900
Cc: Ben Greear <greearb@candelatech.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4CAB59B2.5050106@candelatech.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286479642.20974.32.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010080942.02302.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri October 8 2010 04:27:22 Johannes Berg wrote:
> I'm still convinced something is wrong with ath9k RX DMA, as you've seen
> the contents of frames written to already freed memory regions. Since I
> don't know anything about ath9k, you should probably not rely on me
> though :-)

not sure if this is related or not, but it reminds me of:

"ath9k: BUG kmalloc-8192: Poison overwritten"
http://marc.info/?l=linux-kernel&m=127379077422354&w=2

and:

"ath5k in monitor mode: Poison overwritten on buffers allocated from 
ath_rxbuf_alloc"
https://bugzilla.kernel.org/show_bug.cgi?id=15861

bruno
