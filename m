Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35595 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2AJLOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 06:14:15 -0500
Received: by werm1 with SMTP id m1so3366549wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 03:14:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0C1C0C.2020504@broadcom.com>
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
	<CACna6rzNrFWBJ+n3n9wrnP_Gi3LKCWt+o1Gs38_EjkMgG_k8vg@mail.gmail.com>
	<4F0B67BA.20207@lwfinger.net>
	<4F0C1C0C.2020504@broadcom.com>
Date: Tue, 10 Jan 2012 12:14:14 +0100
Message-ID: <CACna6ry75+cW=M4gAFbf6E3aBqbfKUYEpnkZNAMwTsEvLAg3JA@mail.gmail.com> (sfid-20120110_121419_899115_CF844FCC)
Subject: Re: BCM43231
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>,
	Abimanyu Gottumukkala <me@abimanyu.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/1/10 Arend van Spriel <arend@broadcom.com>:
> On 01/09/2012 11:18 PM, Larry Finger wrote:
>>
>> I remember seeing some mail about the Broadcom guys working on a Linux driver
>> for a USB fullmac device. Is this the one? (I added Arend to the Cc.)
>>
>> Larry
>>
>
> As you know we currently have two linux drivers. brcmfmac is a fullmac
> architecture for cfg80211, brcmsmac is a softmac architecture for
> mac80211. The brcmfmac driver will get usb support soon (when I finish
> my testing over here) but it supports another device (ie. bcm43236).
>
> The bcm43231 has another architecture and can not be supported by either
> of the drivers.

Can you check what chipset is 0846:9020? I didn't see any prove it's
BCM43231 so far. Can you confirm/deny this?

Firmware upload of Windows driver for 0846:9020 looks similar to brcmfmac.

-- 
Rafał
