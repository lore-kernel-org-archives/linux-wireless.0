Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:39615
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZBOWBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 17:01:07 -0500
Message-ID: <4998909F.30106@erley.org> (sfid-20090215_230111_804892_218A5AF1)
Date: Sun, 15 Feb 2009 17:01:03 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E9teut_Alain?= <alain.peteut@space.unibe.ch>
CC: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless-2.6-old (15.02.2009)
References: <20090215224218.da9seiz3s0ks40cg@mail.unibe.ch>
In-Reply-To: <20090215224218.da9seiz3s0ks40cg@mail.unibe.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P=E9teut Alain wrote:
> Hi,
>=20
> I tried to find the solution, but I didn't found the root of the prob=
lem:
> for some reason ../drivers/net/wireless/iwl-4965.c wasn't compiled, b=
ut
> the CONFIG_IWL4965=3Dy was defined config.mk.
> This leads to a not existing struct iwl_cfg iwl4965_agn_cfg which was
> claimed by make during making iwl4965.ko.

I can't comment on this part.
=20
> Since I don't need support for 4965 I set CONFIG_IWL4965=3Dn to overc=
ome
> this issue.
>=20
> I thought I'm fine but this leads to
> ..
> FATAL: Error inserting iwl4965
> (/lib/modules/2.6.26-1-amd64/kernel/drivers/net/wireless/iwlwifi/iwl4=
965.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> ..
> during make load.
> Any suggestions?

We'd need to see the dmesg output (as the error message says) to figure=
 out=20
why that is happening for you. =20

Pat Erley
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
