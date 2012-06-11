Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2FKG45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 02:56:57 -0400
Message-ID: <1339397807.4520.1.camel@jlt3.sipsolutions.net> (sfid-20120611_085723_843881_7D27B1E8)
Subject: Re: [patch v2] iwlwifi: turn on a lockdep assertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Mon, 11 Jun 2012 08:56:47 +0200
In-Reply-To: <20120610112521.GA20676@elgon.mountain> (sfid-20120610_132551_124529_BB46BBBB)
References: <20120610112521.GA20676@elgon.mountain>
	 (sfid-20120610_132551_124529_BB46BBBB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-10 at 14:25 +0300, Dan Carpenter wrote:
> CMD_SYNC is zero so the if (cmd->flags & CMD_SYNC) is never true and we
> never check the assertion.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: enables the assertion even more than v1 (based on feedback from
> Johannes Berg).

Thanks, I picked this up.

johannes

