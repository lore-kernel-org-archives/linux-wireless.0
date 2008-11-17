Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63609 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYKQOY7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 09:24:59 -0500
Subject: Re: Wireless gear on the Romanian market
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: razvan.sandu@zando.ro, linux-wireless@vger.kernel.org
In-Reply-To: <1226832934.5125.21.camel@johannes.berg>
References: <491FF82C.4070207@zando.ro>
	 (sfid-20081116_114659_954211_EE0A4D35)  <1226832934.5125.21.camel@johannes.berg>
Content-Type: text/plain; charset=iso-8859-2
Date: Mon, 17 Nov 2008 09:24:55 -0500
Message-Id: <1226931895.15076.11.camel@dv> (sfid-20081117_152503_081894_99CC5688)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-11-16 at 11:55 +0100, Johannes Berg wrote:
> On Sun, 2008-11-16 at 12:38 +0200, R=E3zvan Sandu wrote:
>=20
> > Now, please, is it possible to find out which of these products are=
=20
> > supported in Linux (or will be in the foreseable future) ? This=20
> > information is critical to Romanian Linux users, as well as others.=
=2E.
>=20
> There's information on this on http://wireless.kernel.org/ and if you
> post the chipsets the devices use we can tell you whether we support
> them or not. But I doubt anyone will go to the trouble and researchin=
g
> the manufacturers for you.

It should be possible to find Windows drivers for the devices, unpack
them and identify what chipsets they are for.  It may happen that
different revisions of the same hardware use different chipsets, so be
sure to check all of the revisions.

The unpacking can be done by running installers in wine or by using
popular archive programs, such as cabextract, unshield, unzip, unrar an=
d
lha.  Identification of the driver can be done by looking into *.inf
files or by using the "strings" command on the *.sys files.

As for the draft 802.11n devices, Intel and Atheros chipsets are
currently supported, except Atheros USB (the work on it is underway).

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
