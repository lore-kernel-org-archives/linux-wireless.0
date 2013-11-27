Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:11320 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3K0P6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 10:58:33 -0500
Message-ID: <5296168A.7020500@open-mesh.com> (sfid-20131127_165836_754422_A7BF8849)
Date: Wed, 27 Nov 2013 16:58:02 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>	<21141.51790.303263.385517@gargle.gargle.HOWL>	<5295EB1D.1050604@meshcoding.com> <21142.4319.977971.553792@gargle.gargle.HOWL> <5296131B.2040003@open-mesh.com>
In-Reply-To: <5296131B.2040003@open-mesh.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 27/11/13 16:43, Antonio Quartulli wrote:
> On 27/11/13 16:33, Sujith Manoharan wrote:
>> Antonio Quartulli wrote:
>>> What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set
>>> within the initvalues?
> 
>> Here is a patch to set ALWAYS_PERFORM_KEY_SEARCH for AR9300 2.2.
>>  Since AR9331, AR9340 and AR9580 use the same array, it applies
>> for them too.
> 
> 

Sujith,

What about AR9285 ? I can't find any reference to this chip. Does it
use the same array too ?


Cheers,


- -- 
Antonio Quartulli
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlhaKAAoJEADl0hg6qKeObVEP/jDCMW7DrNhL4WOWnXBed7TD
0XKppoj2v1xlEX8LSTmzOBj28aZfqPpR6evbX+4B6oWPwQyChsJQnvHSCX5EvXvg
F8uspw1/Kpij5RgTn6GXWnUoBiJTjOHwBRKDwp2HgoKk4plNwwGl1NQ/toEGhYe9
B41Pt5xGFhYFEdu+r4vxss0motF4s/05JPkycbaJe3WP2G47QpuMDHumOshN3CdD
Kd9yP8FZKJVtnsFVUM460VNIwRD69b9TeYbBrEvgkvWZ97Y/S/TFSq2P1UDRr4wG
FLiywN8lDvJ1YrZoaQwqu7R9cXJjLKaOKjt8sVKrARfsCf0SWT6oIqPgpAnYgG7J
YLwM000umrUDZbPjA7dm5LWck3gvnk1eKLRqxW8QZDBagi6pirkpx0lqnqfCRHLV
1B7aBerl27VE5MawNSi/mwMjxRcTHrqBeKY+0ua3cypCrWbjj/qvknJQuB66Ae3A
EYQ6ehPZLCT8od10VJVBOrIF23Tehv4O2xV9KgvbtD+1pvAi9DcyJ5V3Y+r271eF
qEIBMCGtengaWusseTVyglTQ8vbdlzrWhuUJE2Fex01Tf4kD1d2MsH+G1yS1Oo3y
MnUHt4yVtQWCRFcimLEdF9kfF+WtbM+8CSW/xMcih2BqZaE4OVi9Dqzzkdxdx7+t
Ca+g08UoDhC4hmVa0mxX
=wMqg
-----END PGP SIGNATURE-----
