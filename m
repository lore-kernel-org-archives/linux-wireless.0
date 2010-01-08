Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:47793 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0AHWe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 17:34:56 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k: 2.6.32-rc6 "no further txbuf available, dropping packet"
Date: Fri, 8 Jan 2010 23:34:16 +0100
Cc: linux-wireless@vger.kernel.org,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
	ath5k-devel@lists.ath5k.org
References: <4AF99EF9.4040408@nets.rwth-aachen.de> <b6c5339f0911102013k20d927d3mc021d25bf6703303@mail.gmail.com>
In-Reply-To: <b6c5339f0911102013k20d927d3mc021d25bf6703303@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201001082334.16066.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,
I have tried your patch as I get many errors as in subject when I transfer 
huge files (I'm using as a test a 1GB file). With the patch I have the same 
errors.

I'm using wireless-testing.git (v2.6.33-rc2-47131-gc72a18c) in managed mode 
(no AP).

Fabio

On Wednesday 11 November 2009 05:13:03 Bob Copeland wrote:

> Yes, there is a good reason (there are no buffers for the hardware to
> play with).  Actually mac80211 tx is never supposed to return anything
> but TX_OK.
> 
> Try this patch (it needs work which is why it's not upstream yet):
> 
> http://patchwork.kernel.org/patch/56785/
> 
