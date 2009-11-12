Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29512 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbZKLPoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 10:44:37 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 07:44:43 -0800
Date: Thu, 12 Nov 2009 07:44:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Matteo Croce <technoboy85@gmail.com>
CC: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
Message-ID: <20091112154440.GD19349@tux>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com> <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 06:18:46AM -0800, Matteo Croce wrote:
> On Thu, Nov 12, 2009 at 12:31 PM, Lorenzo Bianconi
> <lorenzo.bianconi83@gmail.com> wrote:
> > Hi all
> >
> > I am playing with ath9k/mac80211 in monitor mode and I suspect there
> > is a memory leak.
> > The leak happens when injecting in monitor mode when the destination
> > MAC address is unicast.
> > In fact there is no leak sending broadcast packet.
> > I wrote this minimal test case module which triggers the leak.
> 
> I can reproduce it with ath5k but not with madwifi, so the leak could
> be in mac80211

Can you please resend the thread to linux-wireless for wider review, with
the code snippet and all?

  Luis
