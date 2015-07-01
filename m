Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23593 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbGAHu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 03:50:58 -0400
Date: Wed, 1 Jul 2015 10:50:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Michel von Czettritz <michel.von.czettritz@gmail.com>,
	devel@driverdev.osuosl.org, gregkh@linux.com,
	Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jes.Sorensen@redhat.com
Subject: Re: [PATCH 3/3] staging: rtl8723au: function no longer discards
 return value
Message-ID: <20150701075042.GT28762@mwanda> (sfid-20150701_095107_478311_8206B2E5)
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
 <f1f04f73db3d925d4a790a07fc56154ba98871fc.1435700714.git.michel.von.czettritz@gmail.com>
 <20150701071224.GC2411@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150701071224.GC2411@sudip-PC>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 01, 2015 at 12:42:24PM +0530, Sudip Mukherjee wrote:
> On Tue, Jun 30, 2015 at 11:54:59PM +0200, Michel von Czettritz wrote:
> > The return value of FillH2CCmd in rtl8723a_set_rssi_cmd and
> > rtl8723a_set_raid_cmd is never checked. Both functions always return
> > _SUCCESS.
> > 
> > Both functions now return the return value of FillH2CCmd.
> If they are never checked then why do we need to return some value?
> why not make them void?

They probably *should* be checked eventually?

regards,
dan carpenter

