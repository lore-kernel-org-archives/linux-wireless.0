Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:53686 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3GXMlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 08:41:51 -0400
Received: from mail0.frost.chambana.net (209-66-96-68.chambana.net [209.66.96.68])
	by www19.servergod.com (Postfix) with ESMTP id 2ECCE11FCDA
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jul 2013 05:32:07 -0700 (PDT)
Received: from [0.0.0.0] (unknown [192.168.12.1])
	(Authenticated sender: mccarthy)
	by mail0.frost.chambana.net (Postfix) with ESMTPSA id 29DF7A1A078DAD574055B
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jul 2013 12:34:27 +0000 (UTC)
Message-ID: <51EFC944.40502@opentechinstitute.org> (sfid-20130724_144155_045514_4D7CF592)
Date: Wed, 24 Jul 2013 08:32:04 -0400
From: Jordan McCarthy <mccarthy@opentechinstitute.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: IBSS-RSN support for BCM4313
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linux wireless folk,
	I am a developer at a non-profit working on a wireless mesh networking
platform, and we've just discovered that we have a fleet of netbooks
with the Broadcom 4313 chipset, one that does not work particularly well
(and sometimes not at all) in ad-hoc mode.

What's more, none of the available drivers seem to support IBSS-RSN,
which is absolutely essential for the requirements of our platform.
Accordingly, I wondered if anyone has any experience trying to get the
BCM4313 to work in an IBSS-RSN configuration, and if not, what is needed
to get either of the following:

- - brcmsmac to support adhoc mode
- - b43 to cover the BCM4313

Many thanks,
Jordan

- -- 
Jordan McCarthy
Technical Program Associate | Open Technology Institute | New America
Foundation
My Public Key: 0xC08D8042 | 4A61 3D39 4125 127D 65EA DDC2 BFBD A2E9 C08D
8042
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJR78lDAAoJEL+9ounAjYBClsUH/RgqnocuAhxTyHaXR9EHenhA
ZaSvOQCoCcWP5nOvSNSVHF/xmE7GJq+sPWzQs6O9iLI9bYiSE5NlO1V5wfISaQo/
xxdhczKyVZNFmzUgHnN+HCus99l6wOq5g+nHB8hALP9+iJ9gxJ5zyPVzgiOLLlgZ
3VXLRkQTeNNN/htTPrbiYQ6H/FPHXi4WOOxovpsYWSTw2B0BXwAJXDvP5wsBxzza
W0Gqb25Ipu3z2GtcH1qupPX1myARF1ZIN6hksJPcxgY5g/1IkYVI7kqr5B99ANo8
CCMxi/non3sFSPEBsiDlXKIw2toQG8xmjKYyAh+EY1PLQE48f2XAbj/jbwSmyPo=
=9usr
-----END PGP SIGNATURE-----
