Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42797 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYEZHMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 03:12:01 -0400
Subject: Re: [PATCH V2] iwlwifi: Fix packet injection in iwl3945 and iwl4965
From: Zhu Yi <yi.zhu@intel.com>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <69e28c910805210819ye492edkc20b1ddccdf082ce@mail.gmail.com>
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <69e28c910805210819ye492edkc20b1ddccdf082ce@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Date: Mon, 26 May 2008 15:11:30 +0800
Message-Id: <1211785890.7814.205.camel@debian.sh.intel.com> (sfid-20080526_091206_263811_E43EB7E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-21 at 17:19 +0200, Stefanik G=A8=A2bor wrote:
> this patch really
> fixes packet injection on iwlwifi devices (iwl3945 and iwl4965),
> without causing possible nasty side-effects. Tested with packetspamme=
r
> and aireplay-ng, also works in monitor-while-associated mode.

The mode you enabled is not real "monitor" mode. You can only receive
broadcast/mulitcast frames but not unicast frames destined to other
hosts.

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
