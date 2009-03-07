Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63197 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600AbZCGSQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 13:16:08 -0500
Message-ID: <49B2B9E4.9090006@lwfinger.net> (sfid-20090307_191612_799036_E89C04B4)
Date: Sat, 07 Mar 2009 12:16:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tom Cada <thomas.cada@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Intermittent wlan operation ( b43-phy0 ERROR: PHY transmission
 	error).
References: <960a51b60903070942q31d4d5e2n835f2c642cd19d70@mail.gmail.com>
In-Reply-To: <960a51b60903070942q31d4d5e2n835f2c642cd19d70@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tom Cada wrote:
> I went so far as to download the broadcom-wl-4.150.10.5.3 drivers
> thinking that a more recent version would have addressed the problem.
> However, I found out I couldn't install them with the error:
> 
>  $ ../../b43-fwcutter-011/b43-fwcutter -w /lib/firmware wl_apsta_mimo.o
> Sorry, the input file is either wrong or not supported by b43-fwcutter.
> This file has an unknown MD5sum b84bc801b9b8f39069c252f533655af8.

The driver is b43. What fwcutter gets is firmware. AFAIK, the firmware for your
device that you are using is the same as that of driver 4.150.10.5.3. There is a
difference in the firmware for LP and N PHY devices, but as they are not yet
supported, it doesn't matter.

We are aware of those errors, but don't know why they occur, or how to fix them.
Sorry.

Larry

