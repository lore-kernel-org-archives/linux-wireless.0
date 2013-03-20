Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41466 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3CTPe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 11:34:26 -0400
Received: by mail-oa0-f41.google.com with SMTP id i10so1949333oag.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 08:34:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1456708.37551363792925678.JavaMail.www@wwinf3723>
References: <1456708.37551363792925678.JavaMail.www@wwinf3723>
Date: Wed, 20 Mar 2013 21:04:25 +0530
Message-ID: <CAD2nsn3BQFh4bBeTYND0cyhGrioq2hA1EJj2eh-4EGZoc-kkqQ@mail.gmail.com> (sfid-20130320_163431_323196_0CFCCF04)
Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: nick@nhthomas.freeserve.co.uk
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ ath6kl-devel

On Wed, Mar 20, 2013 at 8:52 PM,  <nick@nhthomas.freeserve.co.uk> wrote:
> Hi
> I tried a wek or so ago to get some help with my ping problems.
>
> Essentially, the problem I see is that my AR6004 based USB wifi adaptor can associate with an AP OK, and gets an IP address via DHCP just fine.
> But, pings don't work.
>
> I can't ping to the device from another PC on the same subnet, and I can't ping out.
>
> And, I think my problem has something to do with MAC addresses.
>
> According to wireshark, pings are received by the USB wifi device OK, but the echo reply is going back out to the wrong MAC address - so it's never received by the ping originator.
>
> Attached is some debug from the driver - which hopefully someone will understand.
>
> Someone suggested that my problem might be endianness related - but I can see that myself - because Association with the AP, and DHCP wouldn't work if that was the case.
> The problem looks to me more like a problem with structure alignment - where the MAC address table is shifted over.
>
>
> You will see in the attached file that the ping originator MAC address is 20:CF:30:94:83:7B
> And, the MAC address of the wifi adaptor itself is 00:03:7F:20:50:59
>
> According to wireshark the MAC address which the echo reply is going back to is neither of these.
>
> Any ideas what's wrong?

care to check with the latest driver and firmware
https://github.com/cernekee/linux-firmware/tree/master/ath6k/AR6004
http://linuxwireless.org/download/compat-wireless-2.6/

AR6004 is pretty decent working.

>
>
> Regards
>
> Nick



-- 
thanks,
shafi
