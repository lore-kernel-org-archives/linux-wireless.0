Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:32683 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2FGBK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 21:10:26 -0400
From: =?utf-8?B?7J207Jq06riw?= <woonki84.lee@samsung.com>
To: 'Samuel Ortiz' <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	kgene.kim@samsung.com
References: <001201cd42ef$c283d8d0$478b8a70$%lee@samsung.com>
 <20120605085919.GI27105@sortiz-mobl>
In-reply-to: <20120605085919.GI27105@sortiz-mobl>
Subject: RE: [PATCH] NFC: Driver for SAMSUNG S3FHRN2 NFC Chip.
Date: Thu, 07 Jun 2012 10:10:24 +0900
Message-id: <000701cd444a$514a39a0$f3deace0$%lee@samsung.com> (sfid-20120607_031030_320166_FEE6F906)
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Samuel.

> 
> Hi WoonKi,
> 
> On Tue, Jun 05, 2012 at 04:49:38PM +0900, �̿��� wrote:
> > This is a driver for the S3FHRN2 NFC device. the driver is just a
> > proxy getting SHDLC/HCI frames from a userspace stack.
> >
> > Signed-off-by: WoonKi Lee <woonki84.lee@samsung.com>
> NACK from me. We started the NFC subsystem to avoid having a new and different
> ad-hoc API for each and every NFC driver, and that's what you're doing right
> here.
> Until this driver gets converted to the kernel NFC APIs, it should live in the
> staging directory.
> 

Ok, I see.
I wonder that if I am able to use NFC API except HCI/SHDLC.
I do not have any API of HCI/SHDLC. This driver assumes the upper layer of kernel
supports them.
Please let me know if I have to use HCI/SHDLC components of NFC subsystem.

Thank you for your review.

Regards,

WoonKi.

