Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763204AbYEVJM6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 05:12:58 -0400
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
Date: Thu, 22 May 2008 17:12:25 +0800
Message-Id: <1211447545.7814.97.camel@debian.sh.intel.com> (sfid-20080522_111312_186441_D1D0284A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-21 at 17:19 +0200, Stefanik G=A8=A2bor wrote:
> also works in monitor-while-associated mode.

How does it work? AFAICS, mac80211 wext.c blocks setting essid and bssi=
d
in monitor mode. Did you patch it?

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
