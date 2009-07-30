Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.domdv.de ([193.102.202.1]:3438 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZG3OIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 10:08:50 -0400
Message-ID: <4A71A6BE.20304@domdv.de>
Date: Thu, 30 Jul 2009 15:57:18 +0200
From: Andreas Steinmetz <ast@domdv.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: wireless-regdb entry for DE wrong
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

[please CC me as I'm not subscribed]

Error in regulatory database for country DE:

The document

http://www.bundesnetzagentur.de/media/archive/5009.pdf

states that the frequency range from 5470 GHz to 5725 GHz can be used
indoor and outdoor, thus the NO-OUTDOOR flag for this range is wrong.

Quick and dirty translation of the relevant text from this document
including the note:

Usage indoor and outdoor. Transmission between within a plane and a
location outside of a plane prohibited.
- --
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFKcaa+V/yW5kkAz4MRAscGAJ4wtUWV6kM8u3nFCstuUrcOD22ZpACgp7Yq
Ipm98KWAFilOCEyannUCIsU=
=t5GW
-----END PGP SIGNATURE-----
