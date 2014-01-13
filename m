Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2984 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaAMQSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:18:54 -0500
Message-ID: <52D411EB.2060708@broadcom.com> (sfid-20140113_171900_598329_23ED00A5)
Date: Mon, 13 Jan 2014 17:18:51 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	Naughtboy <skylvlinux@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>	<52B2E638.8060906@hauke-m.de>	<CAKH5=LsaEw7GEHs5nb1omDeSMmcoFSXo8EEy+DeXvyXF5_1M_g@mail.gmail.com>	<52B300FC.7070204@hauke-m.de>	<52B31392.2070705@broadcom.com>	<CACna6rwU8hroahpVsM7KTJD1iM2=12JuErr5LgCvswx+XsTjjA@mail.gmail.com>	<52B43718.504@broadcom.com>	<CACna6rx_6yyJ88YZ2A5=XjK61xC=F2fX9B54MQcuzcZBOotOrg@mail.gmail.com>	<52D2A7B5.2030003@broadcom.com> <CACna6ryoCeEtCJdC4DKqXVQRVRtxC9s3mCho7wK4ba-ALKAzKA@mail.gmail.com>
In-Reply-To: <CACna6ryoCeEtCJdC4DKqXVQRVRtxC9s3mCho7wK4ba-ALKAzKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2014 09:13 PM, Rafał Miłecki wrote:
> 2014/1/12 Arend van Spriel <arend@broadcom.com>:
>>> Btw. if anyone is interested, I've written a minimal user-space app to
>>> read device info (DL_GETVER) from Broadcom USB dongle.
>>> gcc -lusb-1.0 main.c -o bcmid
>>
>> I see fixed definition for vendor and device id. Given that they differ
>> from what we have in brcmfmac it may be good to use command line
>> argument(s) for these.
> 
> I don't see any real usage possibilities for this app, I just wanted
> to see how "libusb" works and see what's really inside of my WNA3100.
> I don't think anyone is really going to use it ;) Just shared it since
> I already got it ;)
> 

Well, we could put it on the wiki page so people can check before asking
the question.

Gr. AvS
