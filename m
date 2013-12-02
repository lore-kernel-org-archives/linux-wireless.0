Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3LBPCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 10:02:09 -0500
Message-ID: <1385996582.1969.3.camel@dcbw.foobar.com> (sfid-20131202_160213_329665_9BBBAF89)
Subject: Re: Intel (R) PRO/Wireless 2200BG Network Connection
From: Dan Williams <dcbw@redhat.com>
To: tom <thomas.w.cranston@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Dec 2013 09:03:02 -0600
In-Reply-To: <5298070F.3050100@gmail.com>
References: <5298070F.3050100@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-28 at 21:16 -0600, tom wrote:
> Need firmware for Intel Corporation PRO/Wireless 2200BG {Calexico2} 
> Network Connection (rev 05)
> 
> I am running retroprecise 5.4.3 on Dell D620 that has non PAE Celeron 
> CPU. The Linux wireless firmware that came with retroprecise does not 
> work well. IThe wireless works for a few minutes and then disconnects.
> 
> Nov 28 05:17:53 puppypc12586 user.warn kernel: [87435.600488] ipw2200: 
> Firmware error detected.  Restarting.
> Nov 28 05:21:55 puppypc12586 user.warn kernel: [87677.401611] ipw2200: 
> Firmware error detected.  Restarting.
> Nov 28 05:23:37 puppypc12586 user.warn kernel: [87779.789706] ipw2200: 
> Firmware error detected.  Restarting.
> 
> If there is not Linux firmware, what is the Windows XP .ini so that I 
> can use the wrapper?

Can you reply with what firmware version the device is running?  If you
open a terminal and run the command:

dmesg | grep ipw2200

the output should show us what that is.  Latest firmware for the ipw2200
part appears to be version 3.1.

Dan

