Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:52677 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3CWTvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 15:51:47 -0400
Received: by mail-oa0-f52.google.com with SMTP id k14so5345713oag.11
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2013 12:51:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <514E0691.7010909@hauke-m.de>
References: <1363885909-12263-1-git-send-email-hauke@hauke-m.de>
	<CACna6rxAs5hYqePCkVfUXBh2z=W+OWuhCO5J+EqGnUgYOnAGaA@mail.gmail.com>
	<514E0691.7010909@hauke-m.de>
Date: Sat, 23 Mar 2013 20:51:47 +0100
Message-ID: <CACna6rx2eniO8bhHnPZ-6Xq=wMqHo5aE9iWr195G33ORYxCGqQ@mail.gmail.com> (sfid-20130323_205150_891795_5BFE80DC)
Subject: Re: [PATCH] b43: use bcma_pmu_spuravoid_pllupdate()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/23 Hauke Mehrtens <hauke@hauke-m.de>:
> On 03/23/2013 08:34 PM, Rafał Miłecki wrote:
>> 2013/3/21 Hauke Mehrtens <hauke@hauke-m.de>:
>>> Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().
>>
>> Can we wait with this patch few days, please? I'm in process of
>> debugging BCM4322 and channel 13 support, which may be related to this
>> part of driver.
>
> I have not problem with waiting and rebasing my patch onto your fix as
> this is not a fix just a code cleanup.
>
>> Please Cc driver ML when touching it's code.
>
> This was not intended, I just forgot to do so.

Great, thanks :) I'm really glad to see you improving b43, thanks for your work!

-- 
Rafał
