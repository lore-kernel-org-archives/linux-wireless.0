Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52239 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbYGLOrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 10:47:00 -0400
Message-ID: <20080712104659.jsizw0ndw44cw4kc-cebfxv@webmail.spamcop.net> (sfid-20080712_164715_036567_50AE2E97)
Date: Sat, 12 Jul 2008 10:46:59 -0400
From: Pavel Roskin <proski@gnu.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2x00 is still experimental?
References: <1215811139.30975.10.camel@dv>
	<200807121025.43801.IvDoorn@gmail.com>
In-Reply-To: <200807121025.43801.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Ivo van Doorn <ivdoorn@gmail.com>:

> Hi,
>
>> Can we please have rt2x00 drivers considered stable in Linux 2.6.27?
>
> No.
>
>> My experience running rt73 day by day with WPA on a very crowded network
>> shows that it's a pretty reliable driver already.
>
> Perhaps managed mode, but not adhoc mode, beaconing is still broken.
> In addition the leds are broken as well, and hardware encryption   
> isn't in either.

I see.  It must be a perception thing.  Things I hack on seem  
unstable, but things that just work seem stable :)

Thank you for the status.  Good luck with fixing the remaining problems!

-- 
Regards,
Pavel Roskin
