Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout3.wanadoo.co.uk ([80.12.242.59]:33329 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3EHNvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 09:51:45 -0400
Date: Wed, 8 May 2013 15:51:44 +0200 (CEST)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: linux-wireless@vger.kernel.org
Message-ID: <7566504.38231368021104217.JavaMail.www@wwinf3714> (sfid-20130508_155149_068268_7C166D58)
Subject: Wifi signal level differences
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have an Atheros ath6kl_usb based wifi dongle.
I am using it with an embedded project.

The driver code can be built for either X86 or sh4 hardware - so I can also use the same USB wifi dongle on my Fedora 12 Linux PC or plugged in to the embedded device.
It's working fine in both situations.

But, I notice that the signal level reported in /proc/net/wireless is slightly different between the two units.
Note, I am using the same physical Atheros wifi dongle, and moving it from one device to the other to this test.

I notice that when using the X86 PC I see a signal level of -61, which is marginally better than the -66 I see in the embedded device.

I know that this isn't an exact science - but using a short USB extension lead I can orientate the wifi dongle to be in the same place and orientation when plugged in to either device.
So, I would expect the wifi signal strength to be reported the same !?

I know there are many differences between my Fedora 12 PC, and the embedded STLinux project - not least that the driver is compiled using different compilers.

But, I was wondering what else could explain the difference in signal levels between the two?

Also, which part of the driver code is responsible for reading/calculating the signal level value?


Regards

Nick
