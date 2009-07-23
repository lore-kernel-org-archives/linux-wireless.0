Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out9.libero.it ([212.52.84.109]:53601 "EHLO
	cp-out9.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZGWRJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 13:09:55 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WARNING: at net/mac80211/tx.c:561
Date: Thu, 23 Jul 2009 19:07:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <200907230051.57201.rossi.f@inwind.it> <43e72e890907221556r75256f76yde07109d2af78e28@mail.gmail.com>
In-Reply-To: <43e72e890907221556r75256f76yde07109d2af78e28@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200907231907.47751.rossi.f@inwind.it>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 July 2009, Luis R. Rodriguez wrote:

> On Wed, Jul 22, 2009 at 3:51 PM, Fabio Rossi<rossi.f@inwind.it> wrote:
> > I'm using the last wireless-testing.git and I have experienced the
> > following WARNING:
> >
> >  WARNING: at net/mac80211/tx.c:561 ieee80211_tx_h_rate_ctrl+0x3d1/0x470
> > [mac80211]()
>
> Please try a git pull

I was already working with the latest release:
  v2.6.31-rc3-28452-g5bfcdb0
so I confirm that I get the warning quite often (every 15 seconds).


Fabio
