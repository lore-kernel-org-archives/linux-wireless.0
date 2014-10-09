Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:40641 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbaJIKhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 06:37:34 -0400
Received: by mail-ig0-f172.google.com with SMTP id r2so11948086igi.11
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 03:37:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54366332.9060906@msgid.tls.msk.ru>
References: <1412843867-26563-1-git-send-email-zajec5@gmail.com>
	<CACna6ry-+hzMJ4n5PG7GJq9fZ+zwU38HGt-xZkUqKEP8yX6avA@mail.gmail.com>
	<54365985.1020104@broadcom.com>
	<CACna6ryTwBQQnbZg+CSvoYakb4DA1+FH7j-XwfuYmoDzJORenA@mail.gmail.com>
	<543661E1.3050606@broadcom.com>
	<54366332.9060906@msgid.tls.msk.ru>
Date: Thu, 9 Oct 2014 12:37:33 +0200
Message-ID: <CACna6ryEoBYKoRvA7WKJLYva_oUkY+rMjkgo_wj66WhGkxXpgg@mail.gmail.com> (sfid-20141009_123744_456861_B35BC4ED)
Subject: Re: [PATCH][RTF][RFC] brcmsmac: add workaround for old BCM4313
 devices with Bluetooth
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Arend van Spriel <arend@broadcom.com>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	Seth Forshee <seth.forshee@canonical.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 October 2014 12:28, Michael Tokarev <mjt@tls.msk.ru> wrote:
> 09.10.2014 14:22, Arend van Spriel wrote:
>> I know where the function should be called according our driver and guess what:
>>
>>   if (bfl&  BFL_FEM&&  chip == 4313) {
>
> Can you fix whitespace there too, and add parens around the & operation, while at it?

I think you didn't realize it's a pseudo-code / reference ;)
