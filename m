Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36216 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbbIALQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 07:16:05 -0400
Received: by wibz8 with SMTP id z8so28367053wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 04:16:04 -0700 (PDT)
Subject: Re: RTL8189ETV
To: Hans de Goede <hdegoede@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <55E47A27.4090703@gmail.com> <55E48988.1000803@gmail.com>
 <55E49415.7090807@lwfinger.net> <55E4B9A2.8060109@gmail.com>
 <55E5654D.2030607@redhat.com>
From: poma <pomidorabelisima@gmail.com>
Message-ID: <55E588F1.4090100@gmail.com> (sfid-20150901_131609_660412_4057199F)
Date: Tue, 1 Sep 2015 13:16:01 +0200
MIME-Version: 1.0
In-Reply-To: <55E5654D.2030607@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01.09.2015 10:43, Hans de Goede wrote:
> Hi,
> 
> On 31-08-15 22:31, poma wrote:
> 
>> Let's see if Hans knows what type of this device is RTL8189ETV.
> 
> Assuming you are talking about the wifi module of the Allwinner H3
> based Orangepi2 as shown here:
> 
> http://linux-sunxi.org/images/9/96/Xunlong_OrangePi2_front.jpg
> 
> Then we are talking about a realtek sdio wifi module, not usb but sdio!
> 

Care to share link to RTL8189ETV datasheet?

> These wifi modules are not supported at all by upstream kernels atm.
> 
> The path to getting these supported is:
> 
> 1) Find the latest out of tree code for them

I found nothing useful apropos rtl8189etv in "linux sdk source code" 
http://www.orangepi.org/downloadresources/

> 2) Get it to build and work with mainline
> 3) Get it added to staging
> 4) Clean it up, clean it up more, clean it up even more
> 5) Repeat 4
> 6) At one future point hopefully the driver can be moved from staging
>     to drivers/net/wifi
> 

Yeah, let's see is Realtek R&D gonna realize points 2 - 6.
After all, it's their job, right.

> Good luck with this!

Good luck with this!

> 
> Regards,
> 
> Hans
> 
> 
> p.s.
> 
> I agree with Larry that the way you express yourself in your communications
> is not really helpful. Please remember to be excellent to each other.
> 

p.s.
You can agree with whoever you want man,
however I don't understand why you telling me, or what are you talking about in the first place.

p.p.s.
Although it did not help much, thanks for reply.


