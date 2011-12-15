Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1152 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab1LOLkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:40:51 -0500
Message-ID: <4EE9DCBC.2000402@broadcom.com> (sfid-20111215_124055_730018_462A3781)
Date: Thu, 15 Dec 2011 12:40:44 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm: list of smatch warnings
References: <20111215112947.GB3906@elgon.mountain>
In-Reply-To: <20111215112947.GB3906@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2011 12:29 PM, Dan Carpenter wrote:
> Smatch still complains about the brcm driver.  Could you take a look at
> these messages?  It's mostly just cleanups like doing the correct cast
> for min_t() or handling the default cases on switch statements etc or
> verifying that we broke out of a loop instead of coming to the end
> without finding what we were looking for.
> 
> regards,
> dan carpenter
> 

Thanks, Dan

Will sure take a look at those messages. It is on our internal worklist.

Gr. AvS

