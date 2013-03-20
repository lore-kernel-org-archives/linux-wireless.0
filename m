Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout5.wanadoo.co.uk ([80.12.242.80]:47403 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3CTQGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 12:06:53 -0400
Date: Wed, 20 Mar 2013 17:06:51 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <24720158.53141363795611541.JavaMail.www@wwinf3703> (sfid-20130320_170658_340681_3DF68484)
In-Reply-To: <CAD2nsn3BQFh4bBeTYND0cyhGrioq2hA1EJj2eh-4EGZoc-kkqQ@mail.gmail.com>
Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + ath6kl-devel
>
>
> care to check with the latest driver and firmware
> https://github.com/cernekee/linux-firmware/tree/master/ath6k/AR6004
> http://linuxwireless.org/download/compat-wireless-2.6/
>
> AR6004 is pretty decent working.
>

Hi, Yes, I have the latest driver - from Qualcomm.

I think my problem is that I've compiled it for 'sh4' - and it's not guaranteed to work on that platform.

And, indeed it doesn't.

I've just sent out a ping from the wifi adaptor to a PC on the local subnet.
Wireshark says that a ping request was sent out from Src=00:03:7f:20:50:59 (which is correct),
And the destination is Dst=7f:20:50:59:00:5c (which is wrong).

The destination MAC address should be 20:cf:30:94:83:7b .

But, look at the two Src and Dst MAC addresses - they are very similar ! !!?!?!?!

I don't understand where the Dst MAC comes from. That's my bug I think.


Regards

Nick
