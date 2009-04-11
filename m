Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:14400 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZDKE3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 00:29:53 -0400
Received: by fg-out-1718.google.com with SMTP id 16so113789fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2009 21:29:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890904102123o3e280edau933c8235649879c5@mail.gmail.com>
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
	 <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>
	 <49DE7E42.5020700@lwfinger.net>
	 <3ace41890904102123o3e280edau933c8235649879c5@mail.gmail.com>
Date: Sat, 11 Apr 2009 05:29:51 +0100
Message-ID: <3ace41890904102129n2b62001clff35027088bedcd1@mail.gmail.com> (sfid-20090411_062957_623109_8B781B36)
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 11, 2009 at 5:23 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:

> I just gave your patch against compat-wireless, and there isn't any
> noticeable effect other than
> these three lines in dmesg - which at least shows that the new code is active:

Oh, I forgot to mention that to test this code against
compat-wireless, appending "CONFIG_RTL8187_LEDS=y" to config.mk does
the job.

I am wonder if we actually needs an extra Kconfig for this - at least
in my case, the code has no ill effect with device which hasn't got an
RX/TX LED. (other than possibly a small theoretical performance loss
from do extra non-useful work).
