Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496Ab1DZWai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 18:30:38 -0400
Message-ID: <4DB74788.2000908@lwfinger.net> (sfid-20110427_003055_521054_01D6E522)
Date: Tue, 26 Apr 2011 17:30:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan> <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I am trying a different driver now: rt2870sta
> I've read a few reports this may be the 'proper' one to use.
> So far so good, no lag or anything and I did not have to set power off
> either.

Driver rtl2870sta is not the proper one to use. In fact, a patch to delete 
rt2860sta and rt2870sta from the kernel was queued yesterday, and they will be 
gone by the time 2.6.40 is released.

New firmware for rt2800usb was just accepted into the linux-firmware git tree. 
Please obtain a copy and try it.

Larry
