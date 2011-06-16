Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57133 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab1FPUs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 16:48:29 -0400
Received: by fxm17 with SMTP id 17so1363933fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 13:48:28 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Novin <thomas@xyz.pp.se>
Subject: Re: Status of carl9170
Date: Thu, 16 Jun 2011 22:49:13 +0200
Cc: linux-wireless@vger.kernel.org
References: <1308255196.4264.7.camel@thnov-desktop.xyz.lan>
In-Reply-To: <1308255196.4264.7.camel@thnov-desktop.xyz.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201106162249.14480.chunkeey@googlemail.com> (sfid-20110616_224834_095297_D3F145F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 16 June 2011 22:13:16 Thomas Novin wrote:
> When using these to connect to my Ubiquiti Power AP-N I get terrible
> performance. Using another computer with some Broadcom 802.11g chip (b43
> driver) it works OK.
> 
> For example, doing a 100 packet ping towards my LAN gateway and at the
> same time trying to load a webpage.
> 
> --- 10.0.0.254 ping statistics ---
> 100 packets transmitted, 60 received, 40% packet loss, time 99229ms
> rtt min/avg/max/mdev = 0.832/93.193/1264.009/292.193 ms, pipe 2

no problem, here's a ping -c 100 in my setup

--- 192.168.0.254 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99138ms
rtt min/avg/max/mdev = 1.046/2.190/9.561/1.209 ms

But at least, you could try to disable the 11n cap by loading the module
with noht=1 and the hwcrypt by nohwcrypt=1.

Btw, do you have anything in your dmesg from the driver?

Regards,
	Chr
