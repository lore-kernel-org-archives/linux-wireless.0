Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47968 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758303Ab1DMUVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 16:21:37 -0400
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Apr 2011 23:21:30 +0300
Subject: RE: [compat 1/1] compat: add license and other module params to
 kfifo
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401A7BB311D@hasmsx504.ger.corp.intel.com>
References: <1302530175-24451-1-git-send-email-tomas.winkler@intel.com>
 <4DA60515.6000004@hauke-m.de>
In-Reply-To: <4DA60515.6000004@hauke-m.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Hauke Mehrtens [mailto:hauke@hauke-m.de]
> Sent: Wednesday, April 13, 2011 11:18 PM
> To: Winkler, Tomas
> Cc: mcgrof@gmail.com; lrodriguez@atheros.com; linux-wireless@vger.kernel.org
> Subject: Re: [compat 1/1] compat: add license and other module params to
> kfifo
> 
> Hi Tomas,
> 
> On 04/11/2011 03:56 PM, Tomas Winkler wrote:
> > The module taints the kernel if the license is not specified
> >
> > Add also module description
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> I send a patch including kfifo.ko into compat.ko some days ago [0], but
> it was not yet apply. If kfifo is integrated in compat.ko this patch
> will cause problems. As kifo.ko is small I think it is better to get rid
> of this extra module and integrate it into compat.ko.
> 
> [0]: https://patchwork.kernel.org/patch/692651/

Sounds reasonable.
Thanks
Tomas

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

