Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33406 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3CWTe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 15:34:57 -0400
Received: by mail-ob0-f176.google.com with SMTP id er7so1351336obc.21
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2013 12:34:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363885909-12263-1-git-send-email-hauke@hauke-m.de>
References: <1363885909-12263-1-git-send-email-hauke@hauke-m.de>
Date: Sat, 23 Mar 2013 20:34:56 +0100
Message-ID: <CACna6rxAs5hYqePCkVfUXBh2z=W+OWuhCO5J+EqGnUgYOnAGaA@mail.gmail.com> (sfid-20130323_203501_751951_B8495E45)
Subject: Re: [PATCH] b43: use bcma_pmu_spuravoid_pllupdate()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/21 Hauke Mehrtens <hauke@hauke-m.de>:
> Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().

Can we wait with this patch few days, please? I'm in process of
debugging BCM4322 and channel 13 support, which may be related to this
part of driver.

Please Cc driver ML when touching it's code.

-- 
Rafał
