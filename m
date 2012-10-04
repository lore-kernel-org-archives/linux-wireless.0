Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51433 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab2JDSn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 14:43:26 -0400
Date: Thu, 4 Oct 2012 21:43:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch 3/3] brcmfmac: Using zero instead of NULL
Message-ID: <20121004184301.GP13767@mwanda> (sfid-20121004_204332_137144_45318F46)
References: <20121003060713.GC3802@elgon.mountain>
 <506DB904.9000002@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506DB904.9000002@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 04, 2012 at 06:27:48PM +0200, Arend van Spriel wrote:
> On 10/03/2012 08:07 AM, Dan Carpenter wrote:
> >Sparse complains that we use zero instead of NULL here.  In fact, the
> >initialization is wrong and should be removed.  Doing these kinds of
> >bogus initializations means that GCC can't detect unitialized variables
> >and leads to bugs.
> 
> We already had it fixed internally, but your change is more
> sensible. I had it reviewed internally and plan to send it to John
> for 3.8 (ie. wireless-next after merge window). Let me know if that
> is ok with you.

Sounds good.

regards,
dan carpenter

