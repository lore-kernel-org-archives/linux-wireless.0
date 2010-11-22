Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:45601 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0KVSxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:53:20 -0500
Subject: Re: b43 error under heavy load
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CEAB969.20702@lwfinger.net> (sfid-20101122_194209_226222_FFFFFFFFA98AFC1F)
References: <4CEAB969.20702@lwfinger.net>
	 (sfid-20101122_194209_226222_FFFFFFFFA98AFC1F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 19:53:02 +0100
Message-ID: <1290451982.20888.2.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-22 at 12:41 -0600, Larry Finger wrote: 
> Under heavy load with multiple streams, I'm getting errors from my BCM4312
> (14e4:4315) device as follows:
> 
> b43-phy0 debug: TX-status contains invalid cookie: 0x0D4D
> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 76
> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 78
> (and continues).
> 
> Clearly that cookie is garbage as it has a slot number of 0. Any suggestions on
> diagnostic information that I could dump to help debug this?

I think that probably is a firmware or hardware bug. The affected
kernel code was not changed in years, as far as I know.

-- 
Greetings Michael.

