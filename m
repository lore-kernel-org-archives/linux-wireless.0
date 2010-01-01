Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48734 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0AAOTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 09:19:48 -0500
MIME-Version: 1.0
In-Reply-To: <4B3E0061.4000003@unsolicited.net>
References: <4B2FEE46.5030700@unsolicited.net>
	 <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
	 <4B3E0061.4000003@unsolicited.net>
Date: Fri, 1 Jan 2010 15:19:46 +0100
Message-ID: <8db1092f1001010619j66f8b494g86efdd8ddcc3e5e7@mail.gmail.com>
Subject: Re: 2.6.33-rc1 - Weird hard hangs when rendering 'some' web-sites in
	Firefox
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: David <david@unsolicited.net>
Cc: linux-kernel@vger.kernel.org,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/1 David <david@unsolicited.net>:

>>
>
> Mine is a wired connection, so it seems unconnected with that. I've
> replaced the motherboard here and have had no further problems. There is
> now a configuration difference though as I've had to disable radeon kms
> (with radeon.modeset=0) for the new on-board graphics.
>
> My guess is that this is radeon related, and I'm going to set-up the old
> motherboard in a spare case & see what I can work out.
>

I'm not sure. I don't use radeon hardware, only Intel:
cat /boot/config-2.6.33-rc2 | grep -i radeon
# CONFIG_DRM_RADEON is not set
# CONFIG_FB_RADEON is not set

cat /boot/config-2.6.33-rc2 | grep -i kms
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_I915_KMS is not set

Regards


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
