Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:59364 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751355Ab0KAXMW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 19:12:22 -0400
Message-ID: <20101101231220.8591.qmail@stuge.se>
Date: Tue, 2 Nov 2010 00:12:20 +0100
From: Peter Stuge <peter@stuge.se>
To: =?utf-8?B?QmrDtnJu?= Smedman <bjorn.smedman@venatech.se>
Cc: Ben Gamari <bgamari@gmail.com>, ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com> <8762whrqvm.fsf@gmail.com> <AANLkTins=0vM=+qpdDB2-KvMBq6J5vwUjn6Ni76GyQst@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTins=0vM=+qpdDB2-KvMBq6J5vwUjn6Ni76GyQst@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Björn Smedman wrote:
> >> 1. TX DMA hangs under simultaneous high RX and TX load
> >> 2. TX is completely hung but chip is never reset
> >
> > I have also observed both of these behaviors with just a standard
> > hostapd single VIF configuration.
> 
> Thanx Ben, it's a relief to know I'm not the only one suffering
> from this.

Just a note to confirm that I have also seen many different failures
related to this. The lasting impression is that it's a big mess.

I bought my first ath9k hardware roughly a year ago. That was totally
useless as STA up until kernels a few months ago. I am now using an
AR9280 card and for the very first time ath9k hardware and driver is
actually working at all for me, but there are still issues as I noted
in the other email.

Unfortunately they're the kind of issues which can't be debugged much
lacking strong knowledge of device internals.


//Peter
