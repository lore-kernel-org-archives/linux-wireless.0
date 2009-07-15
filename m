Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:57888 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbZGOSMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 14:12:13 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1292575wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 11:12:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
Date: Wed, 15 Jul 2009 11:12:13 -0700
Message-ID: <45e8e6c40907151112k5607e19ewc563097552783559@mail.gmail.com>
Subject: Re: any controller working in AP mode ?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Ram kumar <ramkumar.research@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 14, 2009 at 10:21 PM, Ram kumar<ramkumar.research@gmail.com> wrote:
> 2.Marvell 8388 controller supports AP mode,but it seems marvell has
> not released the AP mode firmware.

http://wireless.kernel.org/en/users/Drivers/libertastf

> 3.Any info on wireless controller that supports AP mode will be helpful to me.

Perhaps the rt2x00 driver?  I've used the USB variant (rt73usb) in AP
mode before but haven't tried it recently.

 -Andrey
