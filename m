Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4924 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794Ab2EOQ52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 12:57:28 -0400
Message-ID: <4FB28AE6.3000700@broadcom.com> (sfid-20120515_185736_559214_19CC71B0)
Date: Tue, 15 May 2012 18:57:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julia Lawall" <julia.lawall@lip6.fr>
cc: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcm80211: brcmu_pkt_buf_free_skb() should handle
 NULL
References: <20120515090027.GG30265@elgon.mountain>
 <4FB26664.2080008@broadcom.com> <20120515144443.GH16999@mwanda>
 <alpine.DEB.2.02.1205151706360.2356@hadrien>
In-Reply-To: <alpine.DEB.2.02.1205151706360.2356@hadrien>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2012 05:07 PM, Julia Lawall wrote:
> 
>   1 - A marker line containing simply "---".
> 
>   2 - Any additional comments not suitable for the changelog.
> 

I guess that 1 can be omitted when there is no 2. I was just wondering
whether the diff command would end up in the changelog when applying the
patch.

Gr. AvS

