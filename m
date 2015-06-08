Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57029 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbFHL0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 07:26:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: support NVRAMs containing pci devpaths (instead of pcie)
References: <1432815561-6639-1-git-send-email-zajec5@gmail.com>
Date: Mon, 08 Jun 2015 14:26:14 +0300
In-Reply-To: <1432815561-6639-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Thu, 28 May 2015
 14:19:21 +0200")
Message-ID: <878ubul9ux.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_132624_351075_0A4A444E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Recently Broadcom added support for NVRAMs with entries for multiple
> PCIe devices. One of the supported formats is based on prefixes defined
> like: devpath0=pcie/1/4/ and entries like 0:foo=bar 0:baz=qux etc.
>
> Unfortunately there are also a bit older devices using different way of
> defining prefixes, e.g. SmartRG SR400ac (2 x BCM43602) with entries:
> devpath0=pci/1/1/
> devpath1=pci/2/1
> Broadcom stated this old format will never be used/supported by brcmfmac
> but given the simplicity of this patch I'll insist on supporting it.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually.

-- 
Kalle Valo
