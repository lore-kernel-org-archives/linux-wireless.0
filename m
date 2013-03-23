Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55188 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab3CWTqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 15:46:37 -0400
Message-ID: <514E0691.7010909@hauke-m.de> (sfid-20130323_204641_208567_970AD4F7)
Date: Sat, 23 Mar 2013 20:46:25 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: use bcma_pmu_spuravoid_pllupdate()
References: <1363885909-12263-1-git-send-email-hauke@hauke-m.de> <CACna6rxAs5hYqePCkVfUXBh2z=W+OWuhCO5J+EqGnUgYOnAGaA@mail.gmail.com>
In-Reply-To: <CACna6rxAs5hYqePCkVfUXBh2z=W+OWuhCO5J+EqGnUgYOnAGaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/2013 08:34 PM, Rafał Miłecki wrote:
> 2013/3/21 Hauke Mehrtens <hauke@hauke-m.de>:
>> Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().
> 
> Can we wait with this patch few days, please? I'm in process of
> debugging BCM4322 and channel 13 support, which may be related to this
> part of driver.

I have not problem with waiting and rebasing my patch onto your fix as
this is not a fix just a code cleanup.

> Please Cc driver ML when touching it's code.

This was not intended, I just forgot to do so.

Hauke
