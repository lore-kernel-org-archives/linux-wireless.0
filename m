Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:65009 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYFfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 01:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <1411597048-25470-1-git-send-email-hauke@hauke-m.de>
References: <1411597048-25470-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 25 Sep 2014 07:35:08 +0200
Message-ID: <CACna6rxOt3Ln8uoN7kgSNDPs+ZWAwnBFEh==e8D+8w3zjL-Peg@mail.gmail.com> (sfid-20140925_073515_629216_CDE71F97)
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
> changes since:
> v4:
>  - move the code adding the device tree to the child driver into this patch
>  - remove all references to irq from this patch

Makes sense, thanks!
