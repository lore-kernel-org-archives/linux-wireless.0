Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9062 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbXKLBPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 20:15:09 -0500
Subject: Re: [PATCH] iwlwifi: Remove unnecessary code in iwl3945 and
	iwl4965 drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
	"John W.Linville" <linville@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200711102049.32921.mboton.lkml@gmail.com>
References: <200711102049.32921.mboton.lkml@gmail.com>
Content-Type: text/plain; charset=GB2312
Date: Mon, 12 Nov 2007 09:08:10 +0800
Message-Id: <1194829690.31574.70.camel@debian.sh.intel.com> (sfid-20071112_011518_781873_0ACCB2C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-11-10 at 20:49 +0100, Miguel Bot=A8=AEn wrote:
> Remove unnecesary code in iwl3945 and iwl4965 drivers.
>=20
> "final_mode" variable is already initialized with the value of the
> "mode" variable.
>=20
> Signed-off-by: Miguel Boton <mboton@gmail.com>

ACK. Or you can do "u32 uninitialized_var(final_mode);". Both are OK
with me.

Thanks,
-yi
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
