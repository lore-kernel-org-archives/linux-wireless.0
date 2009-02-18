Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:39814 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbZBRUCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:02:16 -0500
Received: by bwz5 with SMTP id 5so188746bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 12:02:14 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76c50x-usb: mac80211 port of at76_usb
References: <20090207071701.21485.18763.stgit@tikku>
	<da94abde0902070320g6a98320dhfdb05de8867d5fa7@mail.gmail.com>
	<c4d76b3b0902150920v23db7ad3qf6e69752eade6643@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 22:02:10 +0200
In-Reply-To: <c4d76b3b0902150920v23db7ad3qf6e69752eade6643@mail.gmail.com> (Jason Andryuk's message of "Sun\, 15 Feb 2009 12\:20\:05 -0500")
Message-ID: <87eixvqzst.fsf@litku.valot.fi> (sfid-20090218_210220_383556_1B090414)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

>> I have been testing this for few hours now on ubuntu 8.10 with
>> networkmanager. With iperf I got this warning in some cases:
>>
>> phy0: at76_mac80211_tx called while tx urb is pending
>>
>> Also sometimes first association attempt failed and a second attempt
>> was needed, but otherwise the driver seems to be usable, at least for
>> me. The device I used for testing:
>>
>> Bus 002 Device 006: ID 050d:0050 Belkin Components F5D6050 802.11b
>> Wireless Adapter
>
> After applying the patch to wireless-testing master-2009-02-11, I
> tried it out to poor results.
>
> Attaching my Linksys WUSB11 results in an Oops.  Unfortunately,
> 2.6.29-rc4 has problems with my e1000e, so I cannot set up a
> netconsole.  I will continue to investigate, but all I have for now is
> the below logs.

Thanks for testing. I see also oopses now and I'm looking at your
patches.

-- 
Kalle Valo
