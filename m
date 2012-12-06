Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:58101
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964770Ab2LFCzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 21:55:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20672.2314.800969.75984@gargle.gargle.HOWL> (sfid-20121206_035549_502667_CD6462D6)
Date: Thu, 6 Dec 2012 08:25:06 +0530
To: Adrian Chadd <adrian@freebsd.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	rodrigue@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] qca-swiss-army-knife: Add support to dump AR9003 chips EEPROM
In-Reply-To: <CAJ-VmonMu=98Viwk1qvR-NGrO-qBx2KYT551xaO1KjHEz4Kt3A@mail.gmail.com>
References: <1354612418-6644-1-git-send-email-rmanohar@qca.qualcomm.com>
	<CAJ-VmonMu=98Viwk1qvR-NGrO-qBx2KYT551xaO1KjHEz4Kt3A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> Just a general comment - wouldn't it be cleaner to have the PCI IDs
> and the EEPROM definitions pulled from the ath9k driver source or a
> separate header file, so you don't run the risk of having definitions
> "drift" slightly?
> 
> I doubt that anyone is going to change the cal data format or the
> default templates very often (or at all!), but .. just having those
> definitions duplicated feels wrong to me.

Yes, this would be neat, we should probably be in sync with the
headers in the driver source.

Sujith
