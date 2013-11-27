Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:43359 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3K0Pnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 10:43:53 -0500
Message-ID: <5296131B.2040003@open-mesh.com> (sfid-20131127_164355_565786_44E9B8AC)
Date: Wed, 27 Nov 2013 16:43:23 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>	<21141.51790.303263.385517@gargle.gargle.HOWL>	<5295EB1D.1050604@meshcoding.com> <21142.4319.977971.553792@gargle.gargle.HOWL>
In-Reply-To: <21142.4319.977971.553792@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 27/11/13 16:33, Sujith Manoharan wrote:
> Antonio Quartulli wrote:
>> What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set within
>> the initvalues?
> 
> Here is a patch to set ALWAYS_PERFORM_KEY_SEARCH for AR9300 2.2. 
> Since AR9331, AR9340 and AR9580 use the same array, it applies for 
> them too.



Thanks a lot!


- -- 
Antonio Quartulli
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlhMbAAoJEADl0hg6qKeO0+AQAJhKbyNAwXQNbNyO82zaePRG
WRD2QtPKwNW6O89WZyCP9e63ZqmFDjKaqvLgthclznO2BN+kcOOFIBC0nJ/OKkOl
nzSZnRp6VVrxKHUMj2VbdjTr90ls9v9qf/C1qJTxBTRKxFt8NX2rErGLe3pTZwXp
R9geDAQo2NV2Ho735f7LW9D6f9UyHgYGTVKGm3XDPHdIEz0U/mv0lqbkx3HTsCPx
WVCYgEzqy8cs7Vf+yFHv8iQNhmDtf8UECTKJ9Cvu45np/wDmgFP/AtpY+TN5B1VC
hzBj7OL3BD0hepjUhh8r4SiqR6LyDL+MfHvyL2Y616ZFr+rbHYUYX+V7Fov7w2Om
lovKlcGu4AU4e2kgowGWlfAd5YGif2SNKQ3RiMdTpNsXVlIZMu286urrT5Y8H6pR
eUgThc/5CKpum3a0jCw2FbZr7naC3mJEWVsrB2z8rMvuUnM4ZekwhCHsOMBnQHMf
6sw9Iw7AxujZjTqoF5HgTnaDJb0Op63EUDa3HW+rq3qpRy/RK/qZ+AM0R2pipiO3
wHmlBHOYfct8sHl8Hx3VuEmS9Yd//yJqNcDf7iOriU6rqRrdxrn8VWhSUSEXOg7M
+uohr2ibPLmVQgjFik/Yzi+0lIZ6Lu1E1vE0zGZkgQVxLpqNTugyjW/VZansnG85
3+ddAqwHoioyFFkBcIQE
=XNZ4
-----END PGP SIGNATURE-----
