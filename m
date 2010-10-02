Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63804 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0JBCw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 22:52:29 -0400
Received: by fxm14 with SMTP id 14so999070fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 19:52:27 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Saqeb Akhter <saqeb.akhter@gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
Date: Sat, 2 Oct 2010 04:52:22 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <201010020226.08493.chunkeey@googlemail.com> <AANLkTinrbFLFN7PsVYpxGrnp0==FYVHGdbOBAXsKGWsv@mail.gmail.com>
In-Reply-To: <AANLkTinrbFLFN7PsVYpxGrnp0==FYVHGdbOBAXsKGWsv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010020452.24306.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 October 2010 04:32:04 Saqeb Akhter wrote:
> ------------------------------------------------------------
> Client connecting to 192.168.10.52, TCP port 5001
> TCP window size: 16.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.10.60 port 50647 connected with 192.168.10.52 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec  98.6 MBytes  82.6 Mbits/sec
>  
> Seems to be doing a lot better now thanks :)
Hm, I'm not too optimistic. After all, it took a long time to get to this
point and even now the driver isn't "stable" yet (hence the EXPERIMENTAL
flag).

> I was not aware the WMM extensions were needed to get HT working.
;)

I think 802.11n says somewhere, something like:
"An HT STA is also a QoS STA"

And QoS is enabled/setup by WMM.
> I ended up upgrading my distro to 10.10 RC, and compiling the
> compat-wireless u posted, and enable WMM extensions on my router.
> Working considerably better :)

One more thing: I've updated the firmware to 1.8.8.3
http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary
(In case you are still using the original 1.8.8.1)

Best Regards,
	Christian
