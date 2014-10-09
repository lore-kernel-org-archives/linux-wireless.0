Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:10269 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaJIKq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 06:46:27 -0400
Message-ID: <54366781.8090005@broadcom.com> (sfid-20141009_124630_977080_116876E3)
Date: Thu, 9 Oct 2014 12:46:25 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	Seth Forshee <seth.forshee@canonical.com>,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH][RTF][RFC] brcmsmac: add workaround for old BCM4313 devices
 with Bluetooth
References: <1412843867-26563-1-git-send-email-zajec5@gmail.com>	<CACna6ry-+hzMJ4n5PG7GJq9fZ+zwU38HGt-xZkUqKEP8yX6avA@mail.gmail.com>	<54365985.1020104@broadcom.com>	<CACna6ryTwBQQnbZg+CSvoYakb4DA1+FH7j-XwfuYmoDzJORenA@mail.gmail.com>	<543661E1.3050606@broadcom.com>	<54366332.9060906@msgid.tls.msk.ru> <CACna6ryEoBYKoRvA7WKJLYva_oUkY+rMjkgo_wj66WhGkxXpgg@mail.gmail.com>
In-Reply-To: <CACna6ryEoBYKoRvA7WKJLYva_oUkY+rMjkgo_wj66WhGkxXpgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/14 12:37, Rafał Miłecki wrote:
> On 9 October 2014 12:28, Michael Tokarev<mjt@tls.msk.ru>  wrote:
>> 09.10.2014 14:22, Arend van Spriel wrote:
>>> I know where the function should be called according our driver and guess what:
>>>
>>>    if (bfl&   BFL_FEM&&   chip == 4313) {
>>
>> Can you fix whitespace there too, and add parens around the&  operation, while at it?
>
> I think you didn't realize it's a pseudo-code / reference ;)

Indeed or just me being lazy :-p

Regards,
Arend
