Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:37712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbbAWRiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:38:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wlcore: unlock on error in wl1271_op_suspend()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150115114340.GC17976@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ram Amrani <ramrani@ti.com>, Eliad Peller <eliad@wizery.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20150123173800.940811417B3@smtp.codeaurora.org> (sfid-20150123_183805_320629_1EC6293A)
Date: Fri, 23 Jan 2015 17:38:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We recently introduced a new error path which needs an unlock.
> 
> Fixes: 6d5a748d4836 ('wlcore: add ability to reduce FW interrupts during suspend')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
