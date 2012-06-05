Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094Ab2FEIsx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 04:48:53 -0400
Date: Tue, 5 Jun 2012 10:59:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: =?utf-8?B?77+9zL/vv73vv73vv70=?= <woonki84.lee@samsung.com>
Cc: linux-wireless@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	kgene.kim@samsung.com
Subject: Re: [PATCH] NFC: Driver for SAMSUNG S3FHRN2 NFC Chip.
Message-ID: <20120605085919.GI27105@sortiz-mobl> (sfid-20120605_104858_111742_E6029F75)
References: <001201cd42ef$c283d8d0$478b8a70$%lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <001201cd42ef$c283d8d0$478b8a70$%lee@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi WoonKi,

On Tue, Jun 05, 2012 at 04:49:38PM +0900, �̿��� wrote:
> This is a driver for the S3FHRN2 NFC device. the driver is just a
> proxy getting SHDLC/HCI frames from a userspace stack.
> 
> Signed-off-by: WoonKi Lee <woonki84.lee@samsung.com>
NACK from me. We started the NFC subsystem to avoid having a new and different
ad-hoc API for each and every NFC driver, and that's what you're doing right
here.
Until this driver gets converted to the kernel NFC APIs, it should live in the
staging directory.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
