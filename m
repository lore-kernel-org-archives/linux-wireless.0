Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:44040 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbZKDVvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 16:51:01 -0500
Received: by iwn10 with SMTP id 10so5306544iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 13:51:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF1F653.4000905@irobot.com>
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com>
	<alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz>
	<200911042242.48991.chunkeey@googlemail.com> <4AF1F653.4000905@irobot.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 13:50:46 -0800
Message-ID: <43e72e890911041350i75108dc3g454ab8577d8abacd@mail.gmail.com>
Subject: Re: compat-wireless and minstrel
To: Adam Wozniak <awozniak@irobot.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 1:46 PM, Adam Wozniak <awozniak@irobot.com> wrote:
>
> $ ls -la /lib/firmware/ar9170*
> -rw-r--r-- 1 root root 83968 2009-10-17 15:55 /lib/firmware/ar9170-1.fw
> -rw-r--r-- 1 root root  3508 2009-10-17 15:55 /lib/firmware/ar9170-2.fw
> -rw-r--r-- 1 root root 15960 2009-10-17 15:55 /lib/firmware/ar9170.fw
>
> It is unclear to me which are actually used.

By default the ar9170.fw is tried first, if that fails then the others
are tried. The 2-stage firmware will not be tried if your device
cannot handle it but right now only the AVM Fritz devices can't handle
the 2-stage firmware.

Christian should we just remove 2-stage fw support?

  Luis
