Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n62.bullet.mail.sp1.yahoo.com ([98.136.44.35]:38230 "HELO
	n62.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754426AbYFMIsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 04:48:18 -0400
Message-ID: <4852344E.7020505@yahoo.it> (sfid-20080613_104821_611522_8E6EF4FB)
Date: Fri, 13 Jun 2008 10:48:14 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only	with	disable_hw_scan=1
References: <484FEA26.1040305@gmail.com>	<1213241315.7814.696.camel@debian.sh.intel.com>	<20080612135936.GA5031@tuxdriver.com> <1213342523.7814.865.camel@debian.sh.intel.com>
In-Reply-To: <1213342523.7814.865.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello everybody.

Zhu Yi ha scritto:
> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrote:
>> How does the hardware scan differ from what mac80211 does when
>> scanning?
> 
> Software scan disables Tx during the scan process while hardware scan
> doesn't. So you are expected to see continous ping responds instead of a
> freeze during the scan period. Hardware scan is also more efficient
> since it is handled by the firmware.
> 
>> I still see a lot of mysterious iwlwifi (especially iwl3945)
>> problems in Fedora that seem to disappear with disable_hw_scan=1.
> 
> I don't see this problem from my side. I'll do more testing for 3945.

Me neither. iwl3945's HW scan has always worked properly on my
system. It's a 32bit Core2Duo with latest stable vanilla kernel and
latest compat-wireless driver and mac80211 subsystem.

Never had a single problem with it.

Just a proper-work report.

Thank you for a driver that - at least on my system - is working
great (even from the speed point of view, but that's another topic).


>> Honestly I'm tempted to change it to "enable_hw_scan" instead...
> 
> Give the advantages, I'd like to use it if we can fix the bug (I haven't
> seen what the bug is myself). But you are free to change the default
> value until it is fixed. There is no such problem for 4965, right?


- --
Filippo Zangheri

GPG key ID: 0x6C1F2F2F
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIUjROjzxMG2wfLy8RApPjAJ4sUw0x9TcLYOh/YdIxV/hFWeUbCwCfWaLK
Wk97c4XkgpxvN8RNvzNefJA=
=Gn9F
-----END PGP SIGNATURE-----

