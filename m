Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37837 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760073AbXFASS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 14:18:56 -0400
Message-ID: <4660630E.7040701@lwfinger.net>
Date: Fri, 01 Jun 2007 13:18:54 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John H." <mistamaila@gmail.com>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Upgrade to f7 breaks bcm43xx module
References: <5b9417770706011111u20f32192s960961dc8693f00e@mail.gmail.com>
In-Reply-To: <5b9417770706011111u20f32192s960961dc8693f00e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John H. wrote:
> bcm43xx mac80211:
> YOUR FIRMWARE IS TOO OLD. Firmware from binary drivers older than
> version 4.x is unsupported. You must upgrade your firmware files.
> 
> I get that now with f7 and 2.6.21 and didn't with fc6 2.6.20.
> 
> However, I read that the error is not what it sounds like.  What is
> the solution?

The error is _EXACTLY_ what it sounds like. With fc6, you were using bcm43xx-softmac, which uses V3 
firmware. With fc7, you switched to bcm43xx-mac80211, which needs V4 firmware - just what the error 
message said. The solution is to download a V4 driver and create the appropriate firmware.

Larry
