Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53145 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1GNSni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 14:43:38 -0400
Received: by pvg12 with SMTP id 12so439587pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 11:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310210523-13431-1-git-send-email-hauke@hauke-m.de>
References: <1310210523-13431-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 14 Jul 2011 20:43:38 +0200
Message-ID: <CACna6rzJg1cY76J8C8tNbmYECVFwdZgk_=iMSDg2x844VeHB3A@mail.gmail.com> (sfid-20110714_204341_872065_B9CAF799)
Subject: Re: [PATCH] bcma: add check if sprom is available before accessing it.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/9 Hauke Mehrtens <hauke@hauke-m.de>:
> The SoCs like the bcm4716 do not have a sprom on the bcma bus like a
> pcie device. It stores the values in some partition on flash memory.
> For ssb this informations are read out in the bcm47xx arch code,
> something like that should also be implemented for bcma. Without this
> patch bcma panics on SoCs.

Didn't regress my BCM43224 or BCM4313, seems this flag is safe to use,
Broadcom really cares to set it.

Thanks Hauke.

-- 
Rafał
