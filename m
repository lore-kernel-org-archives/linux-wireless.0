Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3HLIME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 04:12:04 -0400
Message-ID: <1376295095.11514.0.camel@jlt4.sipsolutions.net> (sfid-20130812_101210_091915_1127B311)
Subject: Re: [patch] iwlwifi: pcie: returning positive instead of negative
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Mon, 12 Aug 2013 10:11:35 +0200
In-Reply-To: <20130810230321.GA19051@elgon.mountain> (sfid-20130811_010349_606599_4F723F94)
References: <20130810230321.GA19051@elgon.mountain>
	 (sfid-20130811_010349_606599_4F723F94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-08-11 at 02:03 +0300, Dan Carpenter wrote:
> There is a missing '-' character here so we return positive 'ENOMEM'
> instead of negative.  The caller doesn't care.  All non-zero returns
> are translated to '-ENOMEM' in iwl_pcie_nic_init().
> 
> This is just a cleanup.

Applied, thanks.

johannes

