Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53890 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932994AbeFQK5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 06:57:05 -0400
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org
Cc: Omer Efrat <omer.efrat@tandemg.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [B.A.T.M.A.N.] [PATCH v3 3/5] batman-adv: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Sun, 17 Jun 2018 12:57:02 +0200
Message-ID: <2054994.kXe2AJMHxt@sven-edge> (sfid-20180617_125724_593681_420E32F9)
In-Reply-To: <1529230014-17897-1-git-send-email-omer.efrat@tandemg.com>
References: <1529230014-17897-1-git-send-email-omer.efrat@tandemg.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4792148.4axvnBOdMb"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4792148.4axvnBOdMb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sonntag, 17. Juni 2018 12:06:54 CEST Omer Efrat wrote:
[...]
> --- a/net/batman-adv/bat_v_elp.c
> +++ b/net/batman-adv/bat_v_elp.c
> @@ -114,7 +114,7 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
>  		}
>  		if (ret)
>  			goto default_throughput;
> -		if (!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
> +		if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
>  			goto default_throughput;
>  
>  		return sinfo.expected_throughput / 100;
> 

WARNING: line over 80 characters
#32: FILE: net/batman-adv/bat_v_elp.c:117:
+               if (!(sinfo.filled & BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))

total: 0 errors, 1 warnings, 0 checks, 8 lines checked


Kind regards,
	Sven

--nextPart4792148.4axvnBOdMb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlsmPn4ACgkQXYcKB8Em
e0Yp3xAArwkMnHjoJe08hCYQJydAWHOvNR1MN3dbny/CcZ5GjYRmPXBKZNFDVpbe
BPn1NOU1p65iOvdCfNyoefZoi4VqDm45k8c4sTjLwre979hm0DNoDJ26x69vx9iQ
rhWvXvtgXKIMvjh0PFyB1EU0DDkL7r05AR3taKACRrhaiB/qhWVbZkHLwDtueQnq
hQlOd5W2shw8QMskb7PbuaHAmb8cXQ4RKG2GMpDG/5mYwoABazRIa+Xz8+9GHkAj
3borNFemZB5AVkX7JzGhmgS66Q/R49L2AAvLgr4k3iW8Fwp06xWAYP3tv1p6f30C
kTAigjRmj3Awk4zPEf9bpqxWK5wIcu6b2MppdnBZJcudCyxb9LePL3BY3JNDfJ+I
cIEcEQPPf1h9qncP6qy3LviuwG+je59InbAyKfrI3gjyQlTqGOqNaL4zOGI+vab6
qlH5qH0Apmd1k3uehnSFlR9A4N2S4mISi+PR8HHydDyBSHdKe40EnwMneWOZjlw8
Gi/4MLVmZ0ULII71RyAOTTYLS8SKCLZXlWrw3cXL0xzIVsjihARX48dnlIeOZARD
WttfhgBax7zf42OPlw2d2s07daVT1NcqW61b0ZOJeeNYl3EUfuQ5QdVdo0eiBDza
sVeQw0SJqSq5zmDTVsipMyEgLDkJmGn1+b5ofecvuBwNPHEGeTk=
=F3iS
-----END PGP SIGNATURE-----

--nextPart4792148.4axvnBOdMb--
