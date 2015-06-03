Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:56244 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbbFCRy2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 13:54:28 -0400
Date: Wed, 3 Jun 2015 19:54:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Scott Branden <sbranden@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>, Andrew Kurn <kurn@sfu.ca>
Subject: Re: New USB ID 2001:3c25
Message-ID: <20150603175412.GA7362@1wt.eu> (sfid-20150603_195433_050872_8826B473)
References: <556E6000.90402@lwfinger.net> <6A6FBA3BBCB70741B2E7FD80BFDD32DB2B33CF50@SJEXCHMB10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6A6FBA3BBCB70741B2E7FD80BFDD32DB2B33CF50@SJEXCHMB10.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 03, 2015 at 05:50:49PM +0000, Scott Branden wrote:
> Hi Larry,
> 
> There is no problem applying this patch to the stable tree.
> I didn't know it was my responsibility to inform the stable mailing list every time a patch is accepted
> in the latest kernel that could be applied to the stable tree?

Just adding a Cc: stable@... in the commit message is enough to get it
automatically queued once applied. Please check SubmittingPatches and
stable_kernel_rules.txt for more information.

Regards
Willy

