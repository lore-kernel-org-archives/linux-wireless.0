Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:46058 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYKDTDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 14:03:23 -0500
Date: Tue, 4 Nov 2008 20:03:21 +0100
From: Tino Keitel <tino.keitel+iwl@tikei.de>
To: ipw3945-devel@lists.sourceforge.net
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?utf-8?B?T25kxZllaiBLdcSNZXJh?= <ondrej.kucera@centrum.cz>,
	jikos@suse.cz, yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] PROBLEM: Led for wifi blinking all the time
Message-ID: <20081104190321.GA26456@dose.home.local> (sfid-20081104_200328_115917_3892A54F)
References: <490A5D39.1090605@centrum.cz> <20081031145434.GB4310@tuxdriver.com> <20081103201412.GB8059@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20081103201412.GB8059@x61>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 03, 2008 at 21:14:12 +0100, Tino Keitel wrote:
> On Fri, Oct 31, 2008 at 10:54:35 -0400, John W. Linville wrote:
> > On Fri, Oct 31, 2008 at 02:19:53AM +0100, Ond=C5=99ej Ku=C4=8Dera w=
rote:

[...]

> > > 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945AB=
G =20
> > > Network Connection (rev 02)
> > >
> > > If any other information is relevant, please tell me and I'll try=
 to =20
> > > provide it, too.
> >=20
> > I'm pretty sure this is how the iwlwifi team wants the LEDs to work=
=2E..
>=20
> To change from the annoying blinking to some more decent traffic
> indicator, I wrote a small patch. I attached the version for 2.6.27.

Hi,

sorry, the patch is for 4965. But maybe you can port it to the 3945
driver.

Regards,
Tino
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
