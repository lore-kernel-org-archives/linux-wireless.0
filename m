Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51237 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab1EPOMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 10:12:42 -0400
Received: by bwz15 with SMTP id 15so3764710bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 07:12:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19920.38645.426229.269971@gargle.gargle.HOWL>
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
	<19920.38645.426229.269971@gargle.gargle.HOWL>
Date: Mon, 16 May 2011 10:12:40 -0400
Message-ID: <BANLkTinbt1c7ZvczjLqSHUn3u6LOi7xneA@mail.gmail.com> (sfid-20110516_161254_296901_D1005673)
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
From: George Nychis <gnychis@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Nice. :)
>
> What machine/distro did you use in which the card worked ?
>
> Sujith
>

yep yep, it's an x86 with Ubuntu 10.4 on it.

I tried the xbox adapter, and now I get the same error as Mark:

[333693.330144] usb 2-3: ath9k_htc: Transferred FW: htc_7010.fw, size: 73008
[333693.426523] ath9k_htc 2-3:1.0: ath9k_htc: HTC initialized with 48 credits
[333693.461026] ath: Invalid EEPROM Magic. Endianness mismatch.
[333693.461032] ath: Unable to initialize hardware; initialization status: -22
[333693.461036] ath: Unable to initialize hardware; initialization status: -22
[333693.461043] Failed to initialize the device
[333693.470044] ath9k_htc: probe of 2-3:1.0 failed with error -22

But, I'll move on with the Sony adapter for now.  If you ever want to
try any different firmware for the Xbox adapter, just let me know!
