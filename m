Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:32906 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbbDOOxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 10:53:23 -0400
Received: by oblw8 with SMTP id w8so23576996obl.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2015 07:53:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <552E7761.2040902@openwrt.org>
References: <1429103273-89272-1-git-send-email-nbd@openwrt.org>
	<CACna6ryFjs+YHKUx2WTe5j5xctzD1Aru2qwP=F63TRpMd+FbZQ@mail.gmail.com>
	<552E7761.2040902@openwrt.org>
Date: Wed, 15 Apr 2015 16:53:01 +0200
Message-ID: <CACna6rxFCFjCnOibLw4A+ztZ+bK=iYkTPQQamL5K2DjWsvJr4g@mail.gmail.com> (sfid-20150415_165326_421222_80E9E87C)
Subject: Re: [PATCH 1/2] bcma: use absolute base for SoC GPIO pins
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 April 2015 at 16:36, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2015-04-15 16:33, Rafał Miłecki wrote:
>> Anyway, I'm OK with this patch.
> I don't think I need it, and I didn't want this change to produce
> conflicts on multi-arch builds, so I limited it to the SoC bus only.

OK, thanks.

-- 
Rafał
