Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46206 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab1FVUBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:01:34 -0400
Date: Wed, 22 Jun 2011 15:47:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/13] Initial submission of driver rtl8192de
Message-ID: <20110622194730.GC13533@tuxdriver.com> (sfid-20110622_220137_562683_29F89FBA)
References: <4df279d6.s0xm0gXgTtCYGr4l%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4df279d6.s0xm0gXgTtCYGr4l%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone have any comments on Larry's new driver in the rtlwifi family?

On Fri, Jun 10, 2011 at 03:08:54PM -0500, Larry Finger wrote:
> This series of patches adds a new driver for the Realtek RTL8192DE family
> of devices. The driver is intended to be included in kernel 3.1.
> 
> Included are the following:
> 
> 01/13: rtlwifi: rtl8192de: Merge def.h
> 02/13: rtlwifi: rtl8192de: Merge dynamic management routines
> 03/13: rtlwifi: rtl8192de: Merge firmware routines
> 04/13: rtlwifi: rtl8192de: Merge hardware routines
> 05/13: rtlwifi: rtl8192de: Merge led routines
> 06/13: rtlwifi: rtl8192de: Merge phy routines
> 07/13: rtlwifi: rtl8192de: Merge register definitions
> 08/13: rtlwifi: rtl8192de: Merge rf routines
> 09/13: rtlwifi: rtl8192de: Merge main (sw) routines
> 10/13: rtlwifi: rtl8192de: Merge table routines
> 11/13: rtlwifi: rtl8192de: Merge TX and RX routines
> 12/13: rtlwifi: Fix build problems introduced by merging rtl8192de
> 13/13: rtlwifi: rtl8192de: Modify Kconfig and Makefile routines for new driver
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
