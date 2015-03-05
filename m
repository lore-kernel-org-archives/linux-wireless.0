Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39476 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbbCEMNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:13:51 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Chen Gang <xili_gchen_5257@hotmail.com>,
	Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH next] bcma: prepare Kconfig symbol for PCI driver
References: <1425506825-31844-1-git-send-email-zajec5@gmail.com>
Date: Thu, 05 Mar 2015 14:13:45 +0200
In-Reply-To: <1425506825-31844-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 4 Mar 2015
 23:07:05 +0100")
Message-ID: <8761af63ra.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_131401_728812_B5B88FF5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Driver for PCIe core requires PCI to be enabled, however we shouldn't
> require it for the whole bus. Someone may be not interested in extra
> PCI devices and what's more there are SoCs without any PCI at all (like
> BCM5356C0, BCM5357*, BCM47186B0). For more details see Kconfig "help".
> Please note this patch doesn't allow disabling PCI drivers yet, as it
> requires more work on calls to bcma_core_pci_* functions.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
