Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40384 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYLWVpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 16:45:12 -0500
Date: Tue, 23 Dec 2008 16:37:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH] Revert "iwl3945: remove iwl-3945-led.[ch]"
Message-ID: <20081223213734.GB12572@tuxdriver.com> (sfid-20081223_224517_191682_E6D2630E)
References: <1230000441-15977-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230000441-15977-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 23, 2008 at 10:47:21AM +0800, Zhu Yi wrote:
> This reverts commit b3489137ec7dabe4531c4344347270857301e209. This
> fixes the iwl3945 scan regression reported by Kalle Valo.

Would it be best if I just didn't apply that patch in the first place?

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
