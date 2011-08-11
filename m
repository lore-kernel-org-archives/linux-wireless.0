Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58826 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1HKEjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 00:39:46 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so530042iye.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 21:39:46 -0700 (PDT)
Message-ID: <4E435D0E.80702@lwfinger.net> (sfid-20110811_063949_705987_B5A0A18B)
Date: Wed, 10 Aug 2011 23:39:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [RFC][RFT][PATCH V2 2/2] b43: fix DMA on some bugged hardware
References: <1313001339-11211-1-git-send-email-zajec5@gmail.com>	<1313001339-11211-2-git-send-email-zajec5@gmail.com> <CACna6rynj+OXL1R6jwgnCzReuO+=piOX3LTC9UujDTg4DNBVUw@mail.gmail.com>
In-Reply-To: <CACna6rynj+OXL1R6jwgnCzReuO+=piOX3LTC9UujDTg4DNBVUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2011 07:14 PM, Rafał Miłecki wrote:
> W dniu 10 sierpnia 2011 20:35 użytkownik Rafał Miłecki
> <zajec5@gmail.com>  napisał:
>> Some hardware with 64-bit DMA uses lower address word for setting
>> routing (translation) bit. Add workaround for such boards.
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> ---
>> This requires testing on at least 1 normal 64-bit DMA card and 1 32-bit
>> DMA card. So far it was tested only on my 14e4:4329 where it fixed DMA.
>
> 14e4:4353 (BCM43224), 64-bit DMA, still works :)
>
> The rest will follow tomorrow.

Tested with 14e4:4311 (64-bit) and 14e4:4318 (32-bit). The ssb changes were also 
tested with b43legacy.

Larry
