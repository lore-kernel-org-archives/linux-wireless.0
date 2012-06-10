Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50499 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab2FJTe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 15:34:59 -0400
Message-ID: <4FD4F6DC.2080603@hauke-m.de> (sfid-20120610_213506_120065_23625D5B)
Date: Sun, 10 Jun 2012 21:34:52 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, b43-dev@lists.infradead.org,
	arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/8] bcma: add bcma_pmu_spuravoid_pllupdate()
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de> <1338933307-13446-8-git-send-email-hauke@hauke-m.de> <CACna6rwbS9YTM7gqX14T71Lart2HbUsFo4su8h6HEhv91C_9XA@mail.gmail.com>
In-Reply-To: <CACna6rwbS9YTM7gqX14T71Lart2HbUsFo4su8h6HEhv91C_9XA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2012 06:53 PM, Rafał Miłecki wrote:
> 2012/6/5 Hauke Mehrtens <hauke@hauke-m.de>:
>> This function is needed by brcmsmac. This code is based on code from
>> the Broadcom SDK.
> 
> This is already implemented in b43/phy_n.c:
> 
> /* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
> static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
> 
> I guess we should replace b43 code with a call to introduced function.
> 

Thanks, I looked into b43 but not long enough to find this function. I
will also create a patch replacing this function in b43.

Hauke
