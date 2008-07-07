Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53507 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbYGGBrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 21:47:47 -0400
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200807062244.53787.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806240537.08888.Michal.Kudla@gmail.com>
	 <1214279513.14590.198.camel@debian.sh.intel.com>
	 <200807062244.53787.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Jul 2008 09:45:46 +0800
Message-Id: <1215395146.14590.710.camel@debian.sh.intel.com> (sfid-20080707_034752_515335_19DF7D2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-06 at 22:44 +0200, Micha=C5=82 Kud=C5=82a wrote:
> with new build -rc9 iwl4965 still don't work.
> I don't know, witch distro I should use to check, that current kernel
> and my WiFi is OK.
>=20
> I returned to good 2.6.24-gentoo-r8

This is not a regression. The rfkill subsystem changed a lot since then=
=2E
>From what you reported, it looks like a configuration problem since I
don't see any other report on this. Could you please file a bug on
bughost.org so we can track it there?

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
