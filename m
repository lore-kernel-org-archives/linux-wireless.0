Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50829 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab1DLTYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 15:24:13 -0400
Received: by wwa36 with SMTP id 36so8290534wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 12:24:12 -0700 (PDT)
Message-ID: <4DA4A6D8.2000806@gmail.com>
Date: Tue, 12 Apr 2011 21:24:08 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2800usb: Add three new USB IDs
References: <4DA1E4ED.6080804@gmail.com> <20110411175810.GB2511@tuxdriver.com> <4DA43D3F.60204@gmail.com> <4DA462F0.6090105@lwfinger.net>
In-Reply-To: <4DA462F0.6090105@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2011 04:34 PM, Larry Finger wrote:

> Kill the patch. It appears these are phantom devices, or their original
> inclusion was a mistake.

More ids. But no time for a patch, sorry.


missing, taken from ralink windows driver. And the identified ones come
from ralink linux drivers:

0x04bb,0x094b I-O
0x050d,0x1003 Belkin
0x0586,0x343e RT3070 Zyxel
0x0789,0x0168 Logitec
0x0789,0x0169 Logitec
0x07b8,0x3073 AboCom
0x07b8,0x3074 AboCom
0x08b9,0x1197 RadioShack
0x0b05,0x166a PEGATRON
0x0b05,0x179d ASUS
0x0df6,0x003c Sitecom
0x0df6,0x004a Sitecom
0x0df6,0x004d Sitecom
0x0df6,0x0051 Sitecom
0x0df6,0x0053 Sitecom
0x0df6,0x005f RT3070 Sitecom 3072
0x0df6,0x0060 Sitecom
0x0df6,0x0062 Sitecom
0x13d3,0x3329 AzureWave
0x13d3,0x3365 RT5370 Azurewave
0x148f,0x3573 Ralink
0x148f,0x5370 RT5370 Ralink 5370
0x148f,0x5372 RT5370 Ralink 5370
0x148f,0xf101 Huawei
0x1eda,0x2012 RT3070 Airties
0x2001,0x3c17 Alpha
0x7392,0x7722 Edimax


already at rt2800usb.c, identified from ralink RT3070_RT3370 linux
driver. I believe 8070 == RT33XX :-?

0x07d1,0x3c17 D-Link 8070
0x7392,0x4085 2L Central Europe BV 8070
0x2019,0x5201 Planex Communications, Inc. RT8070

