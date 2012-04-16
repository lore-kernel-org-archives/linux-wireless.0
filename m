Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14890 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab2DPSNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 14:13:25 -0400
Date: Mon, 16 Apr 2012 20:22:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] NFC: remove unneeded NULL check
Message-ID: <20120416182218.GX24130@sortiz-mobl> (sfid-20120416_201330_764419_E9A9B7A4)
References: <20120413192812.GE18505@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120413192812.GE18505@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Fri, Apr 13, 2012 at 10:28:12PM +0300, Dan Carpenter wrote:
> container_of() works by subtracting the offset of the member.  The math
> can't really return a zero here.  Sometimes people check it when they
> actually meant to check something else but in this case we can just
> remove the check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Applied to my nfc-next queue, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
