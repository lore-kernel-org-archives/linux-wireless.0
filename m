Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1924 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1KSR2j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 12:28:39 -0500
Message-ID: <4EC7E739.4080404@broadcom.com> (sfid-20111119_182843_574953_93B0A514)
Date: Sat, 19 Nov 2011 18:28:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Haohui Liao" <liaohaohui@gmail.com>
cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Wireless stalled after a few minutes with Linux Kernel 3.1
References: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
In-Reply-To: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2011 03:20 PM, Haohui Liao wrote:
> Dear Linux wifi developers,
> 
> I didn't encounter core dump problem with kernel 3.1. However, after
> connecting for a few seconds or minutes, the connection with stall and
> I can't assess Internet. I check my dmesg, it gave the following info:
> 
> [ 45.966602] wlan0: direct probe to f4:3f:61:06:22:21 (try 1/3)
> [ 45.969213] wlan0: direct probe responded
> [ 45.998789] wlan0: authenticate with f4:3f:61:06:22:21 (try 1)
> [ 46.001234] wlan0: authenticated
> [ 46.001270] wlan0: associate with f4:3f:61:06:22:21 (try 1)
> [ 46.004102] wlan0: RX AssocResp from f4:3f:61:06:22:21 (capab=0x411
> status=0 aid=1)
> [ 46.004107] wlan0: associated
> [ 93.007527] usb 1-1.3: USB disconnect, device number 3
> [ 95.654157] NET: Registered protocol family 10
> [ 106.263062] wlan0: no IPv6 routers present

Actually, this trace looks fine. The last message means that no IPv6
capable network equipment has been detected. Did you do unplug a USB device?

> Does this mean that the IPv6 in kernel 3.1 is affecting the wifi
> connection?  Please advice.

Provide hardware info.

Gr. AvS

