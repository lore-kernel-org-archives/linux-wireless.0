Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:57559 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3HCRsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Aug 2013 13:48:40 -0400
Received: by mail-ob0-f172.google.com with SMTP id er7so3236075obc.3
        for <linux-wireless@vger.kernel.org>; Sat, 03 Aug 2013 10:48:39 -0700 (PDT)
Message-ID: <51FD4274.3010108@lwfinger.net> (sfid-20130803_194859_803550_A5492C6F)
Date: Sat, 03 Aug 2013 12:48:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: b43: DMA errors with BCM4331 on BCM4706
References: <51FD218E.9040700@hauke-m.de> <20130803185504.022b19d2@milhouse>
In-Reply-To: <20130803185504.022b19d2@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/03/2013 11:55 AM, Michael Büsch wrote:
> On Sat, 03 Aug 2013 17:28:14 +0200
> Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
>> I used wireshark to see what actually happens and the device send out
>> beacons and answers to probe requests without problems. I see the
>> Authentication, Association Request and Association Response frames and
>
> That suggests DMA works for some packets and then fails?
>
>> Does anybody have any thought on this topic?
>
> You should print out more of the DMA values.

Could it possibly work with short packets, but fail on longer ones?

Larry


