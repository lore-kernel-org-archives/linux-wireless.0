Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1EJGmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 02:42:45 -0400
Received: by bwz15 with SMTP id 15so4574156bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 23:42:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19912.55857.505921.694732@gargle.gargle.HOWL>
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
Date: Tue, 10 May 2011 02:42:43 -0400
Message-ID: <BANLkTi=d7BfOBH93bDZMUDV2vhbrVtCgGA@mail.gmail.com> (sfid-20110510_084248_649867_090BD436)
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
From: George Nychis <gnychis@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: Mark Davis <marked86@gmail.com>, linux-wireless@vger.kernel.org,
	Steven <srumney@sbcglobal.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2011 at 2:24 AM, Sujith <m.sujith@gmail.com> wrote:
> Sujith wrote:
>> Sujith wrote:
>> > George Nychis wrote:
>> > > Is there anything more I can do to help here? I've tried older versions of
>> > > compat wireless with older firmware and I am having 0 luck.
>> >
>> > Nope, nothing from your side. I have asked internally if the card could
>> > be used by the HTC drivers without any changes, will update once I get an answer.
>>
>> Can you try the attached firmware ?
>
> Bleh, had a bunch of local changes.
> Can you try this instead ?
>
>

Yep, seems like the same error:

[  206.642427] usb 1-1: ath9k_htc: Transferred FW: htc_7010.fw, size: 73008
[  207.648520] ath9k_htc 1-1:1.0: ath9k_htc: Target is unresponsive
[  207.648549] Failed to initialize the device
[  207.652281] ath9k_htc: probe of 1-1:1.0 failed with error -22
[  207.656271] usbcore: registered new interface driver ath9k_htc

Thanks for trying to help
