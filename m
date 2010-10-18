Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:17590 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab0JRTDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 15:03:06 -0400
Subject: Re: Compat-wireless N900
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext George <george.news@gmx.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287427291.8043.2.camel@powerslave>
References: <4CB6BE57.8010401@gmx.net>
	 <1287071844.11341.5.camel@gnutoo-laptop>
	 <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
	 <4CB74759.3030807@gmx.net>
	 <AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
	 <4CB7F7C7.7030804@gmx.net>
	 <AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>
	 <4CBABB84.1090100@gmx.net> <4CBC7725.7050202@gmx.net>
	 <AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>
	 <4CBC9A51.8030309@gmx.net>  <1287427291.8043.2.camel@powerslave>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 22:02:34 +0300
Message-ID: <1287428554.8043.6.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-18 at 20:41 +0200, ext Luciano Coelho wrote:
> On Mon, 2010-10-18 at 21:04 +0200, ext George wrote:
> > On 18/10/2010 19:21, Luis R. Rodriguez wrote:
> > >> Any help on that? Sorry but I'm somehow desesperate and don't know what to
> > >> do. Actually I'm thinking on not using compat-wireless and nl80211 and get
> > >> back to wireless-extensions.
> 
> Getting back to wireless-extensions would certainly be a very desperate
> measure! :P
> 
> 
> > > Does your device use SDIO or SPI?
> > >
> > >    Luis
> > 
> > I have tried both and none of them have worked.
> 
> On the N900 the wl1271 chip is connected via SPI.
> 
> I'll re-read this thread more carefully to see if I can spot anything
> that could help you.

First thing that came to my mind after re-reading the thread... Does the
wl1251 driver work *without* compat-wireless? Where did you get the
kernel that you have compiled?

My initial guess is that the SPI is not configured correctly so the
probe function is never called in the wl1251_spi module and thus the
interface is never created...


-- 
Cheers,
Luca.

