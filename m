Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39090 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2HJNhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 09:37:42 -0400
Received: by wgbfm10 with SMTP id fm10so1184625wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 06:37:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50250494.5090009@hauke-m.de>
References: <1344447424-30020-1-git-send-email-zajec5@gmail.com>
	<50250494.5090009@hauke-m.de>
Date: Fri, 10 Aug 2012 15:37:41 +0200
Message-ID: <CACna6rwPMuGtGaEvFjQwpaG1S7S7pEA5QE7p7-85LktBXUWcag@mail.gmail.com> (sfid-20120810_153745_837555_2241DE5A)
Subject: Re: [PATCH] ssb: check for flash presentence
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/10 Hauke Mehrtens <hauke@hauke-m.de>:
> On 08/08/2012 07:37 PM, Rafał Miłecki wrote:
>> We can not assume parallel flash is always present, there are boards
>> with *serial* flash and probably some without flash at all.
>> Define some bits by the way.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> Cc: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/ssb/driver_mipscore.c             |   28 +++++++++++++++++++++-------
>>  include/linux/ssb/ssb_driver_chipcommon.h |    4 +++-
>>  2 files changed, 24 insertions(+), 8 deletions(-)
>
> I haven't tested this patch on my devices, but it looks good to me.
> In an additional patch we also need a bool or something like this to
> indicate if there is a parallel, serial or no flash present on the SoC.
> For serial and parallel flash it is not possible to have both of them.

Can I ask why? In theory there are 2 different possible mappings
(SSB_FLASH1 and SSB_FLASH2).

-- 
Rafał
