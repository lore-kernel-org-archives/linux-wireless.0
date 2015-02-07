Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:31562 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbbBGSMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 13:12:30 -0500
Message-ID: <54D6558B.4010500@broadcom.com> (sfid-20150207_191233_183710_0D284FFD)
Date: Sat, 7 Feb 2015 19:12:27 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Benjamin Adler <benadler@gmx.net>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4330 linux support
References: <54D3FF89.502@phoenix-aerial.com> <54D4851F.8020402@broadcom.com> <54D4D37C.2060007@phoenix-aerial.com> <54D4E509.3090308@broadcom.com> <54D57031.9090903@gmx.net>
In-Reply-To: <54D57031.9090903@gmx.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/15 02:53, Benjamin Adler wrote:
>  >> Does AP also work for you?
>  >
>  > Yes, but not sure if your firmware supports it.
>
> Who can I ask for this information?

Can you do a hexdump of your firmware image, ie.:

hexdump -C 4330rtecdc.bin | tail -20

Regards,
Arend
