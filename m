Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbYFMHyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 03:54:44 -0400
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200806112117.01544.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <20080606034738.9835782d.akpm@linux-foundation.org>
	 <1213151464.7814.630.camel@debian.sh.intel.com>
	 <200806112117.01544.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Jun 2008 15:54:21 +0800
Message-Id: <1213343661.7814.868.camel@debian.sh.intel.com> (sfid-20080613_095448_975937_B7E971AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-11 at 21:17 +0200, Micha=C5=82 Kud=C5=82a wrote:
> Still don't work.
> I have tested this patch with and without RFKILL kernel settings
> Compressed result files:
> config-2.6.26-rc5-no-rfkill.txt
> config-2.6.26-rc5-rfkill.txt
> dmesg-2.6.26-rc5-no-rfkill.txt
> dmesg-2.6.26-rc5-rfkill.txt
> are in
> http://michal.kudla.googlepages.com/iwlwifi-problem-with-patch-Zhu-Yi=
=2Eta.bz2

Can you please load the module with "debug=3D0x20002" and attached the
dmesg?

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
