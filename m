Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYGALc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:32:59 -0400
Subject: Re: [PATCH 1/1] mac80211: remove usless tid assignment for
	managment and control frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1214911761-8291-2-git-send-email-tomas.winkler@intel.com>
References: <1214911761-8291-1-git-send-email-tomas.winkler@intel.com>
	 <1214911761-8291-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IP+SJKAeuCmz0KpsdBn7"
Date: Tue, 01 Jul 2008 13:32:15 +0200
Message-Id: <1214911935.29181.7.camel@johannes.berg> (sfid-20080701_133301_350732_D1FCDDD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IP+SJKAeuCmz0KpsdBn7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 14:29 +0300, Tomas Winkler wrote:
> This patch removes useless tid assignment for management and control fram=
es
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/wme.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
> index f23b5a4..30d3b5b 100644
> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -210,7 +210,6 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, s=
truct Qdisc* qd)
>  			kfree_skb(skb);
>  			err =3D NET_XMIT_DROP;
>  	} else {
> -		tid =3D skb->priority & QOS_CONTROL_TAG1D_MASK;
>  		skb_set_queue_mapping(skb, queue);
>  		qdisc =3D q->queues[queue];
>  		err =3D qdisc->enqueue(skb, qdisc);

--=-IP+SJKAeuCmz0KpsdBn7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIahW7AAoJEKVg1VMiehFY4zgP/iEQQhWcTJARx6rtDSSbWLF9
2MzTScDSvr8V2FVJEWfavLnC3PY4TDiPUjQvAXBt/xCDIPwcNAaihlIzSG4Q5bq5
k+FUFo4uaGMGhQMyBvN3sQ4LyY+wjDoA5gkqK8BzDiJON2qf/c6fHkETXsJZMCAB
6N2x9xFrgzcDdf22cxILEAUXXtSHMV3HpNjPbOAVxjuK8lsm5tJa8cq3ggxJIU92
agBoltzsvaRtxgkKncS/QAecVEbl0CoXNG8KANeZlITvDV8RVm+tlazL+zStvFW1
U+FGfjsyjqNL0fcMD5oCvpHfup1iSRGB3sb4g/VUiv+sat5ndD09mrenZz6q/LAI
fhdnRTyG8uFAygdhl45j8so95lop7gchtZCl9By3qnB0xaXDu19Z09umzw8ESi1k
k6IayRQXVmji8PKxwrxD/3IO9gVUQtOsWCgDB80sI1qmikAJKzSPbwGxxwPLoW4n
4TOaQvUuZmpVJyouh1IOe0slUnoNFPtE+f5+hecZdaax30z9eREsf4PFqNzbrE80
OJZeTJ4Vx1+c8sEFDk5cSJNWh60MUtEqY/SF3RaPxYkDeosshofDigh40GOhmgVt
44MRrEt3EqTjfCZnnTw0hDhmNoskc29WDrObbWxPGG76eHZgxoQIXUYXA3xYn3th
QT6ierM/p/ahC182Z6J0
=KA6D
-----END PGP SIGNATURE-----

--=-IP+SJKAeuCmz0KpsdBn7--

