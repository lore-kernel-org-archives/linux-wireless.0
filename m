Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64020 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1GDUXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 16:23:46 -0400
Received: by fxd18 with SMTP id 18so5534212fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 13:23:45 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alex <alex9434@gmail.com>
Subject: Re: carl9170: Problems setting up Virtual Interface
Date: Mon, 4 Jul 2011 22:23:33 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com> <201107042202.27366.chunkeey@googlemail.com> <CAMJnVwm4Xp87pF7PHLP7vVqF-LYzsgeso7ZPzPwOC_39mwP_Kw@mail.gmail.com>
In-Reply-To: <CAMJnVwm4Xp87pF7PHLP7vVqF-LYzsgeso7ZPzPwOC_39mwP_Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107042223.33968.chunkeey@googlemail.com> (sfid-20110704_222357_278652_80A9D977)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 04, 2011 10:11:59 PM Alex wrote:
> Great! I now get an additional interface:
> wlan1-wlan0 Link encap:Ethernet  HWaddr <deleted>
>           BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
> 
> is this the one? Is the name wlan1-wlan0 that I should use to connect?
seems like it.

> BTW: What is the interface?
> 
> mon.wlan0 Link encap:UNSPEC  HWaddr <deleted>
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:3521 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:585952 (572.2 KiB)  TX bytes:0 (0.0 B)
It is created by hostapd.

Regards,
	Chr
