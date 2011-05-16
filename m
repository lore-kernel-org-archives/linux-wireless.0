Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65258 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab1EPDRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 23:17:38 -0400
Received: by pvg12 with SMTP id 12so1916270pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 20:17:37 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19920.38645.426229.269971@gargle.gargle.HOWL> (sfid-20110516_051746_361195_8022E595)
Date: Mon, 16 May 2011 08:46:05 +0530
To: George Nychis <gnychis@gmail.com>
Cc: Mark Davis <marked86@gmail.com>, linux-wireless@vger.kernel.org,
	Steven <srumney@sbcglobal.net>
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
In-Reply-To: <BANLkTinHoZXNMJMGwUW5M4Yge5=nNZMSeA@mail.gmail.com>
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
	<19913.25619.615324.60744@gargle.gargle.HOWL>
	<BANLkTinv0XrfhDZWYpmdzSdVXZCovzhy_g@mail.gmail.com>
	<19914.42954.285439.226672@gargle.gargle.HOWL>
	<BANLkTi=uW+fVNyFJBS0fHMRAQxMKTDgaLw@mail.gmail.com>
	<BANLkTimTH6ffeqTFSvaiNdQB9+wHs5EODA@mail.gmail.com>
	<BANLkTika=AbksZhiykxBbS3VOFVEQY+EtQ@mail.gmail.com>
	<BANLkTinHoZXNMJMGwUW5M4Yge5=nNZMSeA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

George Nychis wrote:
> I finally have this working with compat-wireless-2011-05-13 on a third
> machine, with v1.2 of the hardware.  A little bit of weirdness in the
> device name though:
> 
> wlan%d    IEEE 802.11abgn  ESSID:off/any
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
> 
> "wlan%d" ... seems like a bug trying to insert the number in to the string.
> 
> Thank goodness this works... the difference between the machines?  I'm
> not sure yet.  This is good news though.
> 
> Although the xbox 360 adapter is not UB94, I will still try it on this
> machine tomorrow to see if it initializes or anything.

Nice. :)

What machine/distro did you use in which the card worked ?

Sujith
