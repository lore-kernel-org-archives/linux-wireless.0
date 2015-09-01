Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbbIAIoA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 04:44:00 -0400
Subject: Re: RTL8189ETV
To: poma <pomidorabelisima@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <55E47A27.4090703@gmail.com> <55E48988.1000803@gmail.com>
 <55E49415.7090807@lwfinger.net> <55E4B9A2.8060109@gmail.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <55E5654D.2030607@redhat.com> (sfid-20150901_104405_987833_1C5400AD)
Date: Tue, 1 Sep 2015 10:43:57 +0200
MIME-Version: 1.0
In-Reply-To: <55E4B9A2.8060109@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 31-08-15 22:31, poma wrote:

> Let's see if Hans knows what type of this device is RTL8189ETV.

Assuming you are talking about the wifi module of the Allwinner H3
based Orangepi2 as shown here:

http://linux-sunxi.org/images/9/96/Xunlong_OrangePi2_front.jpg

Then we are talking about a realtek sdio wifi module, not usb but sdio!

These wifi modules are not supported at all by upstream kernels atm.

The path to getting these supported is:

1) Find the latest out of tree code for them
2) Get it to build and work with mainline
3) Get it added to staging
4) Clean it up, clean it up more, clean it up even more
5) Repeat 4
6) At one future point hopefully the driver can be moved from staging
    to drivers/net/wifi

Good luck with this!

Regards,

Hans


p.s.

I agree with Larry that the way you express yourself in your communications
is not really helpful. Please remember to be excellent to each other.
