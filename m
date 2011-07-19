Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45314 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1GSROD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 13:14:03 -0400
Received: by pvg12 with SMTP id 12so4027267pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 10:14:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2596FB.5030105@gnu.org>
References: <1311062701-3455-1-git-send-email-zajec5@gmail.com>
	<4E2596FB.5030105@gnu.org>
Date: Tue, 19 Jul 2011 19:14:01 +0200
Message-ID: <CACna6ry+tSdBJOr8RimHusWJw+cKZuxwdhoi0CHmE-TKJo5PtA@mail.gmail.com> (sfid-20110719_191410_446436_A1A623BC)
Subject: Re: [PATCH 1/2] bcma: inform drivers about translation bits needed
 for the board
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 19 lipca 2011 16:38 użytkownik Pavel Roskin <proski@gnu.org> napisał:
> On 07/19/2011 04:05 AM, Rafał Miłecki wrote:
>>
>> When using DMA, drivers need to pass special translation info to the
>> hardware.
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>
> I'm not sure why you are copying it to me.

Upd, I've used bash history and the last send-email was with --cc to you.


>> +       switch (bus->hosttype) {
>> +       case BCMA_HOSTTYPE_PCI:
>> +               return 0x40000000;
>
> This is already implemented in ssb_dma_translation(), and the constant is
> called SSB_PCI_DMA.  I think we need a named constant here as well, either
> SSB_PCI_DMA or a new constant BCMA_PCI_DMA.


-- 
Rafał
