Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36547 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759708AbYARVJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 16:09:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Subject: RE: iwl3945 driver is still unusable!
Date: Fri, 18 Jan 2008 13:09:37 -0800
Message-ID: <D936D925018D154694D8A362EEB08920036F2DBF@orsmsx416.amr.corp.intel.com> (sfid-20080118_210949_978458_5043B6EB)
In-Reply-To: <47910F33.2090505@archlinux.org>
References: <fmclu6$dvl$1@ger.gmane.org> <fmpigk$c57$1@ger.gmane.org> <D936D925018D154694D8A362EEB08920036F286F@orsmsx416.amr.corp.intel.com> <47910F33.2090505@archlinux.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: =?iso-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, January 18, 2008 12:42 PM, Thomas B=E4chler  wrote:

>> ipw3945 is deprecated - we focus our effort on iwlwifi at this time.
>=20
> Which doesn't help anyone if it does not work. ipw3945 may be
> deprecated in your eyes, but for me it is the only way to make my
> wireless NIC work
> reliably. From my point of view ipw3945 is stable and iwl3945
> is _alpha_
> software.

Please understand that we need to focus limited resources. ipw3945 is d=
eprecated and we focus on iwlwifi, which supports both 3945 and 4965. U=
nfortunately we have been unable to reproduce your problem.=20

> It is, but if you read my E-Mail, you will notice that the driver
> included in 2.6.24 is unusable, thus my request to use a newer driver
> with a _stable_ kernel. The wireless-dev is based on the latest
> linux-2.6 git, which is not always stable.

=46or this purpose I suggest that you consider the compat-wireless proj=
ect. See http://www.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-w=
ireless-2.6.git and http://linuxwireless.org/download/compat-wireless-2=
=2E6/.

Reinette

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
