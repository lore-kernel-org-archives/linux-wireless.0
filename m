Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63464 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946949Ab3BHUhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:37:02 -0500
Received: by mail-pa0-f49.google.com with SMTP id kp6so2270841pab.36
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 12:37:01 -0800 (PST)
Subject: Compile for ARM
From: Marlon Smith <marlon.smith10@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Feb 2013 12:36:58 -0800
Message-ID: <1360355818.5851.19.camel@marlon-Z68X-UD3H-B3> (sfid-20130208_215344_361916_1D55A890)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I'm having some problems with the Ralink supplied driver for my RT3070
USB dongle, so I'd like to try using your driver instead.  I downloaded
compat-wireless-2012-12-18 and I would like to compile it for ARM.
Running ./scripts/driver-select rt2x00 complains about i686 stuff (which
it should), and I figure I need to set some configuration option to
compile for ARM instead.

Can anyone point me in the right direction for this?

Thanks

Marlon

