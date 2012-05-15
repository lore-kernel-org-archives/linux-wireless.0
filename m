Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16588 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2EOOla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:41:30 -0400
Date: Tue, 15 May 2012 17:44:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcm80211: brcmu_pkt_buf_free_skb() should handle NULL
Message-ID: <20120515144443.GH16999@mwanda> (sfid-20120515_164135_059601_4349B3D0)
References: <20120515090027.GG30265@elgon.mountain>
 <4FB26664.2080008@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB26664.2080008@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 04:21:24PM +0200, Arend van Spriel wrote:
> On 05/15/2012 11:00 AM, Dan Carpenter wrote:
> > This is potentially called with NULL pointers, for example, look at
> > brcmf_c_prec_enq().  Since it's a free() function, probably people
> > expect it to handle NULL pointers.
> 
> Acked-by: Arend van Spriel <arend@broadcom.com>
> 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
> > index b45ab34..3e6405e 100644
> 
> Is the diff command filtered properly here. In most patches I usually
> see '---' immediatly after the Signed-off-by line.
> 

Yeah.  Normally git puts the diffstat there, but my scripts leave
it out.  All my patches are tiny anyway.  ;)

regards,
dan carpenter

