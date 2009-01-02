Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36750 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759325AbZABTz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 14:55:28 -0500
Received: by bwz14 with SMTP id 14so20394193bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 11:55:25 -0800 (PST)
Message-ID: <da94abde0901021155x47aa5c34u85f0a9b7f41fa8cf@mail.gmail.com> (sfid-20090102_205534_756034_2C31535B)
Date: Fri, 2 Jan 2009 21:55:25 +0200
From: "Kalle Valo" <kalle.valo@iki.fi>
To: Claudio <der.claudio@aon.at>
Subject: Re: status of at76-usb driver
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1230923532.495e670ca90b6@webmail.aon.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11844363.2869.1230645164289.JavaMail.root@WARSBL214.highway.telekom.at>
	 <87fxk1902j.fsf@litku.valot.fi>
	 <1230923532.495e670ca90b6@webmail.aon.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 2, 2009 at 9:12 PM, Claudio <der.claudio@aon.at> wrote:
> Kalle Valo <kalle.valo@iki.fi> wrote:
>> I tried twice with latest Ubuntu 8.10 (updated yesterday) and kernel
>> oopsed both time for me:
>
> So it did for me.
>
> But the at76_usb that comes with Ubuntu 8.10 is actually a (very old)
> 0.14beta1 version. Try $ strings /lib/modules/`uname \\
> -r`/kernel/ubuntu/misc/wireless/at76/at76_usb.ko | egrep \'0.1[47]\'
>
> Ad 1: It seems like Ubuntu ships an outdated version of the old
> stand-alone driver.
>
> Ad 2: I\'ve found a work-around (I\'ve tried this earlier but it did not
> work for any reason): adapting and compiling the 0.17 version of the old
> stand-alone driver (http://developer.berlios.de/projects/at76c503a/) ->
> It works again.
>
> Since this is not the perfect solution I would like to find out how to
> enable the at76 driver from the staging tree and then vote for doing the
> same in the Ubuntu kernel package. Well, how do I enable this driver
> anyway?

I think at76_usb was included to 2.6.28 and I doubt that ubuntu uses
so new kernel yet.

> Or what do you think we should do?

Better to use the stand-alone driver from berlios for now and wait for
ubuntu to upgrade 2.6.28.

Kalle
