Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:37613 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYCKJnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 05:43:09 -0400
Date: Tue, 11 Mar 2008 10:42:36 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Recent driver in linux kernel 2.6.25-rc2
Message-ID: <20080311094236.GB4344@ics.muni.cz> (sfid-20080311_094317_362876_01E877D6)
References: <20080219153910.GA4303@ics.muni.cz> <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com> <20080219224418.GA20926@ics.muni.cz> <D936D925018D154694D8A362EEB0892003DB2DC5@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <D936D925018D154694D8A362EEB0892003DB2DC5@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2008 at 05:35:32PM -0700, Chatre, Reinette wrote:
> sorry for the delay - please do submit a bug at bughost.org to enable=
 us
> to track this problem.
>=20
> The error you get is strange - the reason why the channel could not b=
e
> set was because the device is not considered to be ready. Yet, from y=
our
> debug log all the required steps appear to have completed successfull=
y.
> Could you please add a print to the function
> iwl4965-base.c:iwl4965_is_ready to see what the value of priv->status
> is?

I don't have this problem in 2.6.25-rc3 and rc4. However, it seems that=
 the
card does not associate with AP if I set iwcofnig wlan0 essid any. Is t=
his=20
a bug or a feature? The AP does not use key and is visible.

--=20
Luk=E1=B9 Hejtm=E1nek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
