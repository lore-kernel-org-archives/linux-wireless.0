Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64908 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbbANWVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 17:21:18 -0500
Received: by mail-ie0-f182.google.com with SMTP id x19so11599787ier.13
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 14:21:18 -0800 (PST)
MIME-Version: 1.0
From: Bryan Quigley <gquigs@gmail.com>
Date: Wed, 14 Jan 2015 17:20:57 -0500
Message-ID: <CAAWf5=sCKA3w_snEqJzNSCk8DSCVc5Bv1HXooGLicg3GFX9xBQ@mail.gmail.com> (sfid-20150114_232143_782709_32180C23)
Subject: Packet loss on rtl8188ee
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I've been seeing packet loss on this laptop using a rtl8188ee wireless
card on Ubuntu 14.10 with compat-wireless 3.19rc4 kernel. I've tried
it with two routers and many different settings.  My test case is ping
-i 0.02 -c 100 with the laptop next to the router, and I run it at
least 3 times to be certain.

On other devices I can do this over and over again with no packet loss
to the same router.

I've been debugging it here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1401741

I've tried enabling debug options (but nothing obvious when packets
are dropped), changing channels (6 seemed to be best), changing Wifi
Security, changing module options, but still get some dropped packets.
it does *seem* better running compat-wireless 3.19rc4, but that might
be in my head..

Is there a better test case for packet loss?  Just ping for longer?
The debug logs I've been able to generate don't appear to do anything
special on packet loss.  Any suggestions?

The packet loss greatly effects web apps during light to moderate
usage (think Email and a few websites) to the point of making it
unusable.

Thanks!
Bryan
