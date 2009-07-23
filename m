Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out7.libero.it ([212.52.84.107]:59581 "EHLO
	cp-out7.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZGWRbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 13:31:24 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WARNING: at net/mac80211/tx.c:561
Date: Thu, 23 Jul 2009 19:28:44 +0200
Cc: linux-wireless@vger.kernel.org
References: <200907230051.57201.rossi.f@inwind.it> <200907231907.47751.rossi.f@inwind.it> <43e72e890907231021m46139567s3de4ed4cc2812938@mail.gmail.com>
In-Reply-To: <43e72e890907231021m46139567s3de4ed4cc2812938@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907231928.44337.rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 July 2009, Luis R. Rodriguez wrote:

> On Thu, Jul 23, 2009 at 10:07 AM, Fabio Rossi<rossi.f@inwind.it> wrote:
> > On Thursday 23 July 2009, Luis R. Rodriguez wrote:
> >> On Wed, Jul 22, 2009 at 3:51 PM, Fabio Rossi<rossi.f@inwind.it> wrote:
> >> > I'm using the last wireless-testing.git and I have experienced the
> >> > following WARNING:
> >> >
> >> >  WARNING: at net/mac80211/tx.c:561
> >> > ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]()
> >>
> >> Please try a git pull
> >
> > I was already working with the latest release:
> >  v2.6.31-rc3-28452-g5bfcdb0
> > so I confirm that I get the warning quite often (every 15 seconds).
>
> What channel is your AP on?
> Is your AP 00:0c:f6:xx:xx:xx ?

Yes, that is my AP configured on channel 8 (Frequency 2.447 GHz):

          Cell 05 - Address: 00:0C:F6:xx:xx:xx
                    Channel:8
                    Frequency:2.447 GHz (Channel 8)
                    Quality=48/70  Signal level=-62 dBm
                    Encryption key:on
                    ESSID:""
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=000000007803aa0c
                    Extra: Last beacon: 4352ms ago
                    IE: Unknown: 0000
                    IE: Unknown: 010482848B96
                    IE: Unknown: 030108
                    IE: Unknown: 050400010000
                    IE: Unknown: 2A0104
                    IE: Unknown: 32080C1218243048606C
                    IE: Unknown: DD07000C4301000000


Fabio
