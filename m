Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4653 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab2EOO2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:28:48 -0400
Message-ID: <4FB26815.9090400@broadcom.com> (sfid-20120515_162854_186299_7DA7D037)
Date: Tue, 15 May 2012 16:28:37 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcm80211: brcmu_pkt_buf_free_skb() should handle
 NULL
References: <20120515090027.GG30265@elgon.mountain>
 <4FB26664.2080008@broadcom.com>
In-Reply-To: <4FB26664.2080008@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2012 04:21 PM, Arend van Spriel wrote:
> On 05/15/2012 11:00 AM, Dan Carpenter wrote:
>> This is potentially called with NULL pointers, for example, look at
>> brcmf_c_prec_enq().  Since it's a free() function, probably people
>> expect it to handle NULL pointers.
> 
> Acked-by: Arend van Spriel <arend@broadcom.com>
> 
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>

Hi Dan,

By the way. You cc'ed Greg <gregkh@suse.de> but he moved to linux
foundation.

Gr. AvS


