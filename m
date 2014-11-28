Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36081 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaK1Mmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 07:42:31 -0500
Date: Fri, 28 Nov 2014 13:42:23 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] NFC: llcp: Use list_for_each_entry in llcp_accept_poll
Message-ID: <20141128124223.GF29389@ribalta.mp.intel.com> (sfid-20141128_134235_289160_7476BF1C)
References: <1415269241.17088.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415269241.17088.1.camel@phoenix>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Axel,

On Thu, Nov 06, 2014 at 06:20:41PM +0800, Axel Lin wrote:
> list_for_each_entry_safe() is necessary if list objects are deleted from
> the list while traversing it. Not the case here, so we can use the base
> list_for_each_entry variant.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  net/nfc/llcp_sock.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.

