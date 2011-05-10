Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:45188 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab1EJQKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 12:10:51 -0400
Received: by pxi16 with SMTP id 16so4331310pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 09:10:51 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19913.25619.615324.60744@gargle.gargle.HOWL> (sfid-20110510_181055_869864_97C222D6)
Date: Tue, 10 May 2011 21:43:07 +0530
To: George Nychis <gnychis@gmail.com>
Cc: Mark Davis <marked86@gmail.com>, linux-wireless@vger.kernel.org,
	Steven <srumney@sbcglobal.net>
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
In-Reply-To: <BANLkTi=BrJPhjA5StJcktkKE7zs3Ob=iOg@mail.gmail.com>
References: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
	<BANLkTi=Z=i9_WoXX=YbQtF-8imKizRPM+w@mail.gmail.com>
	<BANLkTim_uY0Di13RDHZxOpVQZaDfG3hc8A@mail.gmail.com>
	<19903.49991.848934.183819@gargle.gargle.HOWL>
	<BANLkTi=1E-Ma=N0D-gP_baSjMOvmfM-2KQ@mail.gmail.com>
	<BANLkTi=wXtCNY7TUUpfYpHux8piL09+RuQ@mail.gmail.com>
	<BANLkTiknq4jDQY2-z53QXoyHUb4b4=Oojw@mail.gmail.com>
	<BANLkTi=tZDXs=ja+YKXFVyP3FeuxmWLtuA@mail.gmail.com>
	<19908.11423.898062.510184@gargle.gargle.HOWL>
	<BANLkTin6qOChJQSmjoByS9C2_toFzHNq=A@mail.gmail.com>
	<BANLkTi=X+_cQP7RJh9Y4fPQhbJbgfNK6pQ@mail.gmail.com>
	<BANLkTinvVGrVdmku3G6hEmbv+9+nOwnZPA@mail.gmail.com>
	<19912.44045.774181.844464@gargle.gargle.HOWL>
	<19912.55320.817869.173186@gargle.gargle.HOWL>
	<19912.55857.505921.694732@gargle.gargle.HOWL>
	<BANLkTi=d7BfOBH93bDZMUDV2vhbrVtCgGA@mail.gmail.com>
	<19912.57383.634547.405469@gargle.gargle.HOWL>
	<BANLkTi=BrJPhjA5StJcktkKE7zs3Ob=iOg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

George Nychis wrote:
> > Hm, looks like 0x0411 doesn't match. Can you try this FW ?
> >
> >
> 
> [  393.053564] usb 1-1: new high speed USB device using ehci_hcd and address 5
> [  393.525139] usb 1-1: ath9k_htc: Transferred FW: htc_7010.fw, size: 73008
> [  394.525196] ath9k_htc 1-1:1.0: ath9k_htc: Target is unresponsive
> [  394.525335] Failed to initialize the device
> [  394.548205] ath9k_htc: probe of 1-1:1.0 failed with error -22

Well, looks like my FW hack didn't work out. I will be getting a UWA-BR100,
so I'll play around with it and we'll see where it goes. :)

Sujith
