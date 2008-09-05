Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYIEH6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 03:58:06 -0400
Subject: Re: kernel crash during suspend using iwl3945 driver 1.2.26k
	on	ubuntu hardy
From: Zhu Yi <yi.zhu@intel.com>
To: Karol Szkudlarek <karol@mikronika.com.pl>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20080903T181136-957@post.gmane.org>
References: <48BC47C5.2070807@mikronika.com.pl>
	 <1220425598.28282.190.camel@debian.sh.intel.com>
	 <loom.20080903T181136-957@post.gmane.org>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 15:55:00 +0800
Message-Id: <1220601300.28282.291.camel@debian.sh.intel.com> (sfid-20080905_095810_624638_D1CEA0E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-03 at 18:22 +0000, Karol Szkudlarek wrote:
> Tests I performed with
> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2 which
> is
> compat-wireless-2008-08-06 and git-describe v2.6.26-rc9-14214-g9cb3010
> and compat-wireless-2008-07-25 and git-describe
> v2.6.26-rc9-14207-ga520bdb
> with the same result...

Please see if 2.6.27-rc kernels fix this problem. The wme_qdisc stuff is
removed in .27.

Thanks,
-yi

