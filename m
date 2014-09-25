Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55030 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIYFsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 01:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <1411597048-25470-1-git-send-email-hauke@hauke-m.de>
References: <1411597048-25470-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 25 Sep 2014 07:48:09 +0200
Message-ID: <CACna6rx7d56-94Tsn=rb+FaS89DYZuvA1ZOFoSpRVCsVvPvWZA@mail.gmail.com> (sfid-20140925_074814_635442_0A94EB09)
Subject: Re: [PATCH v5 1/2] bcma: register bcma as device tree driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
	varkabhadram@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2014 00:17, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
> give the address of the chipcommon core in device tree and bcma will
> search for all the other cores.

Hauke: I just noticed you sent this V5 patch as 1/2. I was wondering
if it makes a sense to treat it as a standalone patch? Should we ask
John to pick this one and you could work on this IRQ stuff
independently?
