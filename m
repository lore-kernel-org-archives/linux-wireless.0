Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7675 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674AbcCRIsN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 04:48:13 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH v2 0/7] mwifiex: cleanups 
Date: Fri, 18 Mar 2016 08:48:08 +0000
Message-ID: <b7934b465768468fa693154e21aeebd4@SC-EXCH04.marvell.com> (sfid-20160318_095051_750554_EF31304D)
References: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
In-Reply-To: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> From: Andreas Fenkart [mailto:afenkart@gmail.com]
> Sent: Thursday, March 10, 2016 2:14 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Nishant Sarmukadam; Julian Calaby; Kalle Valo;
> Andreas Fenkart
> Subject: [PATCH v2 0/7] mwifiex: cleanups
> 
> v2:
> - addressed issues from review
> - race-condition issue discussed in patch description
> 
> Andreas Fenkart (7):
>   mwifiex: scan: simplify dereference of bss_desc fields
>   mwifiex: scan: factor out has_ieee_hdr/has_vendor_hdr
>   mwifiex: scan: simplify ternary operators using gnu extension
>   mwifiex: scan: factor out dbg_security_flags
>   mwifiex: scan: replace pointer arithmetic with array access
>   mwifiex: factor out mwifiex_cancel_pending_scan_cmd
>   mwifiex: make mwifiex_insert_cmd_to_free_q local static
> 
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c      | 125 +++++++-------
>  drivers/net/wireless/marvell/mwifiex/main.h        |   3 +-
>  drivers/net/wireless/marvell/mwifiex/scan.c        | 185 ++++++++------
> -------
>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  13 +-
>  4 files changed, 128 insertions(+), 198 deletions(-)
> 

Thanks for the efforts for this cleanup work. Patches look fine to me.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
