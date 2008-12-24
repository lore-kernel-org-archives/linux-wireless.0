Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49781 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYLXBQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 20:16:50 -0500
Subject: Re: [PATCH] Revert "iwl3945: remove iwl-3945-led.[ch]"
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20081223213734.GB12572@tuxdriver.com>
References: <1230000441-15977-1-git-send-email-yi.zhu@intel.com>
	 <20081223213734.GB12572@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 24 Dec 2008 09:18:14 +0800
Message-Id: <1230081494.2570.64.camel@debian.sh.intel.com> (sfid-20081224_021655_404470_D033AE52)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-24 at 05:37 +0800, John W. Linville wrote:
> > This reverts commit b3489137ec7dabe4531c4344347270857301e209. This
> > fixes the iwl3945 scan regression reported by Kalle Valo.
> 
> Would it be best if I just didn't apply that patch in the first place?

Sure. Just the patches after this one might not be applied cleanly. But
it's obvious to fix.

Thanks,
-yi

