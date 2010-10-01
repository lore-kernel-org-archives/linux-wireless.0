Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0JAWwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 18:52:43 -0400
Received: by fxm14 with SMTP id 14so943433fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 15:52:42 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: carl9170: wnda3100 only 54MB/s
Date: Sat, 2 Oct 2010 00:52:34 +0200
Cc: Saqeb Akhter <saqeb.akhter@gmail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <201010011636.58033.chunkeey@googlemail.com> <AANLkTimZYgDLLag+uGgdojrckZ5tgySC+UeyHCfee74J@mail.gmail.com>
In-Reply-To: <AANLkTimZYgDLLag+uGgdojrckZ5tgySC+UeyHCfee74J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201010020052.35855.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 October 2010 00:30:28 Saqeb Akhter wrote:
> Below is the out put from iperf on windows (about 3x faster).
> 
> Not sure what to do to get better throughput...is this considered a bug or a
> lacking feature ?
nope, the "feature" is there... It's just not utilized 
 
> -------------------------------------------------------------------------------
> sakhter@sakhter-laptop:~$ iw dev wlan2 link
> Connected to 30:46:9a:10:49:f7 (on wlan2)
>     SSID: sakhter-5g
>     freq: 5200
>     RX: 222040 bytes (949 packets)
>     TX: 12082 bytes (77 packets)
>     signal: -45 dBm
>     tx bitrate: 54.0 MBit/s
are you sure carl9170 is actually handling the device (and not ar9170usb?).
Also what's the chosen rate control alg? ( - dmesg - will tell you that,
if it isn't "minstrel_ht", then post please post what "iw dev wlan2 scan"
shows you about your AP)

Regards,
	Chr
 
