Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:41716 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002Ab0BQHoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 02:44:02 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: give warning if building w/out rate ctrl algorithm
Date: Wed, 17 Feb 2010 08:40:24 +0100
Cc: Andres Salomon <dilinger@collabora.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>
References: <20100216161656.42079d77@droptest.queued.net>
In-Reply-To: <20100216161656.42079d77@droptest.queued.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002170840.24127.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I discovered that if EMBEDDED=y, one can accidentally build a
> mac80211 stack and drivers w/ no rate control algorithm.

I think this is fine. I'm working with embedded devices (AVR32 &
ARM) as well. And I usually turn on CONFIG_EMBEDDED=Y because I
want to really fine-tune my kernel to my device.

And therefore I know my hardware.

And because I know my hardware, I can decide on my own if I need 
rate ctrl or not.

-- 
http://www.holgerschurig.de
