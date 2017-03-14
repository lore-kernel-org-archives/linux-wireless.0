Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37175 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbdCNOGl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:06:41 -0400
Received: by mail-wm0-f49.google.com with SMTP id n11so64778859wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 07:06:40 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, simon.wunderlich@openmesh.com,
        Benjamin Berg <benjamin@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Allow multiple listeners for management frames.
Date: Tue, 14 Mar 2017 15:06:35 +0100
Message-ID: <33102038.DFbxuT1K2h@bentobox> (sfid-20170314_150658_582294_132453C2)
In-Reply-To: <1489499461.10872.4.camel@sipsolutions.net>
References: <20170310093454.27664-1-sven.eckelmann@openmesh.com> <1489499461.10872.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1928938.xUc1NH9JM6"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1928938.xUc1NH9JM6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Dienstag, 14. M=E4rz 2017 14:51:01 CET Johannes Berg wrote:
[...]
> I'm not sure I mentioned it to him, or even remembered it when we were
> discussing it, but I don't think this patch is a good idea, at least
> for action frames.
[...]
> If you restrict it to non-action I can live with it, but I don't know
> what you really want to do with this.

I think he required it only for probe requests.

Kind regards,
	Sven
--nextPart1928938.xUc1NH9JM6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAljH+OsACgkQXYcKB8Em
e0biaBAAs5fUCCZg2hwECLo06waIZpCpBORUG+V1aO+kSYfnGma4edPCU/dhLYUH
3hjqBWMz1/Q61JcmU0lTcKpJPbw4w/IEqgzq6n26W2I2dXrqBAUWuHHHMW6BKNKp
D/AauKdeUb9BpIPXfpwCPOmO5NPCgYotJnsnzl/mg4I8QBv1gwOAcnZRDfoovyp6
++gQ+j646oMPVmz9HMZhu632nGjblp1ItaE/7S3reV8jBy+AUdYYfXVOCVFFAan1
x+hXST9t+RKb89E9stPjYjovkA4Pqr4RgpSX1hv6aCbVMtqZdKi85GvbB7gINovr
k9lkWWljQjLFzeZJVB6xNL04qAW8vkpcTPsfcGl9TLnsASA21hALq0xGnHDRQxho
6fCjRyBFGxz+7zQmVx6s/JSnMwqlJfIbI8vVeMDE1Z8r4T0HPgJNchGDphqWGQ1K
KNgjVrkDQ8O3FtQGgBoJPRjmEGYQYZA9jnUs2QfOzLqcsfnHvEB1oJKDULV08/10
KZvXpaNLLoj7Ay890cdB1MYkNqP1w4Sg1kvAlLri7v+4VWSDARcT/oGv044vkIXd
FOzBl8rqFG1IowM26PfH1BjKwXDJdhKsed9+TKeCnEZHuQEEXs3nn8tOwtu0lAPw
P6Dd5Na5+7pi6aKnXC7dXd7WjPXc/qVmLUeA3y5Sf51edq2s8wk=
=wnWv
-----END PGP SIGNATURE-----

--nextPart1928938.xUc1NH9JM6--
