Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbYFQBLm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 21:11:42 -0400
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200806162021.37105.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806131937.03680.Michal.Kudla@gmail.com>
	 <1213581088.7814.882.camel@debian.sh.intel.com>
	 <200806162021.37105.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Jun 2008 09:11:28 +0800
Message-Id: <1213665088.2533.24.camel@debian.sh.intel.com> (sfid-20080617_031153_095662_65553BC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-16 at 20:21 +0200, Micha=C5=82 Kud=C5=82a wrote:
> And my wifi working!
>=20
> Bt, I don't know why my wifi working under 2.6.23 and 2.6.24?

mac80211 in those (old) kernels doesn't indicate to switch the SW
rf_kill on with user sets txpower off.

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
