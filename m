Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:53598 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1JRIgB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 04:36:01 -0400
Date: Tue, 18 Oct 2011 10:39:25 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] iwmc3200wifi: add some more range checks
Message-ID: <20111018083924.GA2275@sortiz-mobl> (sfid-20111018_103609_900824_FEEBED2F)
References: <20111012081036.GA32384@elgon.mountain>
 <20111012082656.GA13878@sortiz-mobl>
 <20111018065043.GB25814@longonot.mountain>
MIME-Version: 1.0
In-Reply-To: <20111018065043.GB25814@longonot.mountain>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Tue, Oct 18, 2011 at 09:50:43AM +0300, Dan Carpenter wrote:
> My previous patch added a check to get_key() but missed a couple
> other places which need range checks.
> 
> The problem here is that wifi drivers have different numbers of keys.
> The lower levels assume that they can have up to 4 default keys and
> 2 management keys but this driver only has the default keys so we
> could go past the end of the ->keys[] array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

