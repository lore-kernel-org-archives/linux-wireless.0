Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56958 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbZLBMmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 07:42:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: fix two warnings
Date: Wed, 2 Dec 2009 13:42:30 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1259749236.32171.151.camel@johannes.local>
In-Reply-To: <1259749236.32171.151.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912021342.33239.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 December 2009 11:20:36 Johannes Berg wrote:
> My gcc appears to be able to see past the function
> boundary and notices that the variable 'behaviour'
> could be used uninitialised:
> 
> drivers/net/wireless/b43/leds.c: In function ‘b43_leds_register’:
> drivers/net/wireless/b43/leds.c:339: warning: ‘behaviour’ may be used uninitialized in this function
> drivers/net/wireless/b43/leds.c: In function ‘b43_leds_init’:
> drivers/net/wireless/b43/leds.c:262: warning: ‘behaviour’ may be used uninitialized in this function
> 
> because b43_led_get_sprominfo() didn't initialise
> it in all cases.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ack


-- 
Greetings, Michael.
