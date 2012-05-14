Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11257 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab2ENUXN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 16:23:13 -0400
Date: Mon, 14 May 2012 22:32:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH -next] nfc: shdlc needs to select CRC_CCITT
Message-ID: <20120514203244.GD12740@sortiz-mobl> (sfid-20120514_222329_442448_CED18349)
References: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au>
 <4FB16765.3090602@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB16765.3090602@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Randy,

On Mon, May 14, 2012 at 01:13:25PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build error: SHDLC uses crc_ccitt so it should select CRC_CCITT.
> 
> ERROR: "crc_ccitt" [net/nfc/hci/hci.ko] undefined!
A similar patch was sent a few days ago by Marcel Holtmann.
It is queued to my nfc-fixes branch and I included it to a pull request I sent
to John last week.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
