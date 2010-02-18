Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:52302 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0BRHl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 02:41:59 -0500
Message-ID: <4B7CE958.5030402@openwrt.org>
Date: Thu, 18 Feb 2010 08:16:40 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	8an@praha12.net
Subject: Re: [PATCH] iw: add country IE parsing
References: <1266459208-12408-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1266459208-12408-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez írta:
> Spits out the channels as seen on the IE, useful when debugging
> issues with APs. When found the equivalent distance of the
> coverage class is printed out in meters.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> Sorry, resending, I mistakenly sent to lkml instead of linux-wireless.
> 
> OK so I removed the line that says we're printing IEs and also
> added a distance compuation based on Luká¹ Turek's forumal.
> 
> coverage = (distance + 449) / 450;
> coverage/450 = distance + 499

You have to multiply both sides of the equation by the same value.
Additionally, you did change 449 to 499.


