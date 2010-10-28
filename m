Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:37323 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755694Ab0J1VsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 17:48:22 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Realtek rtl8188 support?
Date: Thu, 28 Oct 2010 23:48:13 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com> <201009212120.07914.s.L-H@gmx.de> <4CC9C067.9040105@lwfinger.net>
In-Reply-To: <4CC9C067.9040105@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010282348.16673.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thursday 28 October 2010, Larry Finger wrote:
> On 09/21/2010 02:20 PM, Stefan Lippers-Hollmann wrote:
[...]
> As part of the inclusion of r8712u in staging, Greg KH asked for a TODO item to
> convert the firmware to an external binary. I see this as a 2 step process: (1)
> get the firmware binary accepted into linux-firmware, and (2) make it work with
> the external loading mechanism. Step 1 has been completed with the following
> commit message:
> 
> commit c500ee5be41b7954ba9630d7e5d409a24efaf249
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Wed Oct 20 11:49:59 2010 -0500
> 
>     Convert firmware for Realtek RTL8192SU (rtl8712u) from embedded to
>     an external file.
> 
>     Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> The code for step 2 is running locally. I'm waiting for the new version of
> linux-firmware to propagate through the distros before I submit the patch. If

I assume you refer to rtl8712u.bin in your r8712u_firmware tree:
http://git.kernel.org/?p=linux/kernel/git/lwfinger/r8712u_firmware.git;a=blob_plain;f=rtl8712u.bin
200fd952db3cc9259b1fd05e3e51966f  *rtl8712u.bin

> you want to grab the new firmware package, I can send you a copy of the patch.

I'd very much like to test the patch(2) needed for rtl8712, if possible.

Regards
	Stefan Lippers-Hollmann
