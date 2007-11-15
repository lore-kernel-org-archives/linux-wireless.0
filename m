Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4269 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXKOVbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 16:31:42 -0500
Date: Thu, 15 Nov 2007 16:31:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: Remove unnecessary code in iwl3945 and
	iwl4965 drivers
Message-ID: <20071115213118.GE12902@tuxdriver.com> (sfid-20071115_213147_863391_99C66FFB)
References: <200711102049.32921.mboton.lkml@gmail.com> <1194829690.31574.70.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1194829690.31574.70.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2007 at 09:08:10AM +0800, Zhu Yi wrote:
>=20
> On Sat, 2007-11-10 at 20:49 +0100, Miguel Bot=F3n wrote:
> > Remove unnecesary code in iwl3945 and iwl4965 drivers.
> >=20
> > "final_mode" variable is already initialized with the value of the
> > "mode" variable.
> >=20
> > Signed-off-by: Miguel Boton <mboton@gmail.com>
>=20
> ACK. Or you can do "u32 uninitialized_var(final_mode);". Both are OK
> with me.

I think I like this alternative better...

--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
