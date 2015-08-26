Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36960 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbbHZVyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 17:54:52 -0400
Received: by igui7 with SMTP id i7so22823178igu.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2015 14:54:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
Date: Wed, 26 Aug 2015 23:54:51 +0200
Message-ID: <CACna6rxG7ewu0G_MP1L_yS-3nbgNSB_Zo_Wapv0Lumjib=_QWw@mail.gmail.com> (sfid-20150826_235505_665937_8268DAE3)
Subject: Re: [PATCH 00/12] brcmfmac: multiple interface rework and cleanup
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 August 2015 at 22:14, Arend van Spriel <arend@broadcom.com> wrote:
> This patch series contains the following:
> * rework code dealing with multiple interfaces.
> * allow logging firmware console using debug level.
> * fix crash in error path when probe fails.
> * fix memory leak in free net devices.
> * minor code cleanup.
>
> The patch series is intended for v4.3 and applies to the master
> branch of the wireless-drivers-next repository.

This is a bulk of great work, thank you! I can finally use 3 AP
interfaces without any problems and WARNINGs!

I tested it on my SmartRG SR400ac with 2 x BCM43602, I did:
1) Setup 3 AP interfaces on 2 GHz 20MHz HT with WPA2 PSK
2) Switch my STA 25 times between APs
3) Run iperf for 20 minutes (33.2 Mbits/sec)
4) Switch my STA 25 times between APs

Not a single failure noticed! My BCM43602 finally works stable! Great
work, thanks again!
