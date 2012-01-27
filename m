Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1734 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2A0KIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 05:08:16 -0500
Message-ID: <4F227784.10309@broadcom.com> (sfid-20120127_110819_888037_8347DB7A)
Date: Fri, 27 Jan 2012 11:08:04 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Milan Bouchet-Valat" <nalimilan@club-internet.fr>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 keeps disconnecting with brcmsmac and multiple APs
References: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
In-Reply-To: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2012 11:31 AM, Milan Bouchet-Valat wrote:
> [    2.489970] usb 2-1.3: New USB device found, idVendor=0a5c, idProduct=21b4
> [    2.489978] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    2.489984] usb 2-1.3: Product: Broadcom 2070 Bluetooth
> [    2.489988] usb 2-1.3: Manufacturer: Broadcom Corp
> [    2.489992] usb 2-1.3: SerialNumber: 002713DDD4FC

Hi Milan,

Another thing to consider. I notice that you have a bluetooth device in
there as well. Can you disable that (if possible) and try again.

Gr. AvS

