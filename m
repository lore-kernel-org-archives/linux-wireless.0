Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51157 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYLRPpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 10:45:13 -0500
Date: Thu, 18 Dec 2008 10:31:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Rami Rosen <ramirose@gmail.com>, linux-wireless@vger.kernel.org,
	reinette.chatre@intel.com
Subject: Re: [PATCH] [v3] iwlwifi: iwl-tx.c cleanup (remove unused
	parameters).
Message-ID: <20081218153149.GE4121@tuxdriver.com> (sfid-20081218_164518_437786_8A8524BD)
References: <eb3ff54b0812152335p6f768aa4r7ad68b33e62bd20b@mail.gmail.com> <20081217163908.GD12679@tuxdriver.com> <eb3ff54b0812171351r50de6af0td15bf29d7e863212@mail.gmail.com> <1ba2fa240812171442i2a348e91paf3434d6b975642e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240812171442i2a348e91paf3434d6b975642e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 18, 2008 at 12:42:37AM +0200, Tomas Winkler wrote:
> On Wed, Dec 17, 2008 at 11:51 PM, Rami Rosen <ramirose@gmail.com> wrote:
> > This patch removes unused parameters in methods in iwl-tx.c:
> > remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
> > remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
> > remove a parameter (sta_id ) from iwl_tx_cmd_build_hwcrypto()
> 
> Unicast can go sta_id has to stay, we need it for merging 3945 back

OK, I'll drop this patch and wait for a new submission.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
