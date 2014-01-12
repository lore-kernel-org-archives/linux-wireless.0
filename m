Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60649 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALUNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 15:13:07 -0500
Received: by mail-oa0-f42.google.com with SMTP id n16so7178880oag.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jan 2014 12:13:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52D2A7B5.2030003@broadcom.com>
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>
	<52B2E638.8060906@hauke-m.de>
	<CAKH5=LsaEw7GEHs5nb1omDeSMmcoFSXo8EEy+DeXvyXF5_1M_g@mail.gmail.com>
	<52B300FC.7070204@hauke-m.de>
	<52B31392.2070705@broadcom.com>
	<CACna6rwU8hroahpVsM7KTJD1iM2=12JuErr5LgCvswx+XsTjjA@mail.gmail.com>
	<52B43718.504@broadcom.com>
	<CACna6rx_6yyJ88YZ2A5=XjK61xC=F2fX9B54MQcuzcZBOotOrg@mail.gmail.com>
	<52D2A7B5.2030003@broadcom.com>
Date: Sun, 12 Jan 2014 21:13:05 +0100
Message-ID: <CACna6ryoCeEtCJdC4DKqXVQRVRtxC9s3mCho7wK4ba-ALKAzKA@mail.gmail.com> (sfid-20140112_211325_947450_F3950239)
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Naughtboy <skylvlinux@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/12 Arend van Spriel <arend@broadcom.com>:
>> Btw. if anyone is interested, I've written a minimal user-space app to
>> read device info (DL_GETVER) from Broadcom USB dongle.
>> gcc -lusb-1.0 main.c -o bcmid
>
> I see fixed definition for vendor and device id. Given that they differ
> from what we have in brcmfmac it may be good to use command line
> argument(s) for these.

I don't see any real usage possibilities for this app, I just wanted
to see how "libusb" works and see what's really inside of my WNA3100.
I don't think anyone is really going to use it ;) Just shared it since
I already got it ;)

-- 
Rafał
