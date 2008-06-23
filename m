Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:22832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYFWFGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 01:06:37 -0400
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200806230530.44283.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806162021.37105.Michal.Kudla@gmail.com>
	 <1213665088.2533.24.camel@debian.sh.intel.com>
	 <200806230530.44283.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Jun 2008 13:05:51 +0800
Message-Id: <1214197551.14590.148.camel@debian.sh.intel.com> (sfid-20080623_070639_695417_3FA364F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-23 at 05:30 +0200, Micha=C5=82 Kud=C5=82a wrote:
> >ZY Your radio is disabled by the software rf_kill switch. Please do =
a
> >ZY $ echo 0 > /sys/bus/pci/drivers/iwl4965/<dev id>/rfkill
> \:rfkill0/state
>=20
> Still don't work

Oops, you should echo 1 instead.

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
