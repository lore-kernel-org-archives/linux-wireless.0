Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34354 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760336Ab3HNVjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 17:39:08 -0400
Received: by mail-ie0-f175.google.com with SMTP id s9so12459iec.6
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 14:39:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <520AF3BD.5020705@lwfinger.net>
References: <CAN3-2D7=P=9VyV7xoANw_6B8VhOaTRC1iMw+mwUH2-g8YOmPMg@mail.gmail.com>
	<520968B0.80301@lwfinger.net>
	<CAN3-2D5rCnXYogA6s6in_e6qpyLmZ0bpbGX=REi=Cn29U40nMw@mail.gmail.com>
	<520971BA.6040503@lwfinger.net>
	<CAN3-2D75TLTS-Fv3CgoBjA+RA3jv-QyLoSs+PZeKXLY_MUcSTQ@mail.gmail.com>
	<520975D8.8040908@lwfinger.net>
	<CAN3-2D6KSsFXQ5QOGfp-1c69dCSrCEdcgXMfPcuEC+Hx_dX_zw@mail.gmail.com>
	<520AF3BD.5020705@lwfinger.net>
Date: Wed, 14 Aug 2013 14:39:08 -0700
Message-ID: <CAN3-2D5+tvQyZKBP3vUwGWdctCcfCeBxAhPsZs+DCLDdr4dyCw@mail.gmail.com> (sfid-20130814_233914_023658_AD53C22B)
Subject: Re: issues with RTL8188CE device and rtl8192ce driver
From: Colleen Josephson <cjoseph@mit.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> First, what chip is in your computer. Please send me the output of the
> command '/sbin/lspci -nnv'. Only the stanza for the RTL8188CE will be
> needed. There are at least 4 different chips that work with driver
> rtl8192ce.

03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8195]
Flags: bus master, fast devsel, latency 0, IRQ 17
I/O ports at 5000 [size=256]
Memory at f3800000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
Capabilities: [70] Express Endpoint, MSI 00
Capabilities: [100] Advanced Error Reporting
Capabilities: [140] Virtual Channel
Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
Kernel driver in use: rtl8192ce
Kernel modules: rtl8192ce


> Second, what is the make/model of the access point that you are using? Is
> the firmware up to date?

There are two Meraki M16 access points (with up to date firmware).

> Third, what is the encryption method you are using, and what is the maximum
> rate for the connection? That will tell me if you are using 802.11g or
> 802.11n.

802.11g.  The encryption is WPA & WPA2 Personal, and the maximum rate
is 54 Mbps.
