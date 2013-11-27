Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:26169 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3K0Myp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 07:54:45 -0500
Message-ID: <5295E60D.90600@open-mesh.com> (sfid-20131127_135450_772029_2295429C)
Date: Wed, 27 Nov 2013 13:31:09 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
References: <1385547828-4330-1-git-send-email-sujith@msujith.org> <21141.51790.303263.385517@gargle.gargle.HOWL>
In-Reply-To: <21141.51790.303263.385517@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi Sujith,

On 27/11/13 11:32, Sujith Manoharan wrote:


What patch is addressing this change? And can could please explain a
bit more about what is needed to address the key cache corruption problem?

Right now I am working on a "reactive behavior" which tries to detect
a cache corruption event and subsequently re-install all the keys one
by one to ensure they are back to a proper state.

What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set within the
initvalues?

Sorry for shooting all these questions at once, but I am really trying
to understand how to properly address this issue.


Cheers,


- -- 
Antonio Quartulli
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSleYNAAoJEADl0hg6qKeO7p4P/RBa9tGDY1xYTTlHNATh4WfX
kIIPdM7x8/+S/wQPKndZ4TPJpBjsnXVnSMhcjMDjbepFRmx40FcElj/ObvKhB3Mc
lMawsFyCEQHjUdNbSS01c3DYmbxw1YM1DUPl2N2XQKaiXbd8Zz7Rr71k8npDt07C
3LScQeiWvj6TOwP89hXnfz2sBRPkhA4z1rTP7omr3CV9N8Ik6E23LsUnijgG8bgI
w5XZ4NGZaVn75TdTsdk8wFm853R2/on5rb0CACHV9Z7T/oT8QM3fKMhEV6pR97wI
P1Titinssw65ycOHlMcGmUi0DoFZHQUuI6LX2V4o5Vr1nsYN8WkQiRu7iy8MiESO
nLdxK+5VKXL0Tf3roN3CxBzINwE9GsL2EmkvjtUZy4SdAGB7H5+QCs+/XBhB3aTH
eeJo2nVdFGNNhrTOfdUdNfpwYvwwAzMHBYxARwifPG3g718a/xSlSsjDDTuSY7+x
656CD7Nbuq3JzVlfM//QEOb07N9xuEcXiSDdghY7GsJzBN+T2eS6vG57S/V4/ecj
1n7opm+f0+2vjZs/SGiykKyphWFuKY89TAXA67bP91qmYLmrdZccJtrqv/zEhfqO
Z1lXYvM1X5SAb5Kbmj/8YPz/ZdmGxGSDRVQa8f4ujXCZ8gR4gA6eNkGprPljos6N
LSZyNHlxM8Adgx20NC/+
=ONks
-----END PGP SIGNATURE-----
