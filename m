Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26886 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbYLICdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 21:33:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 18:33:12 -0800
Date: Mon, 8 Dec 2008 10:33:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Norbert Preining <preining@logic.at>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless-2008-12-06 =?utf-8?Q?a?=
	=?utf-8?Q?nd_no_member_named_=E2=80=98requeue=E2=80=99?=
Message-ID: <20081208183327.GC6035@tesla> (sfid-20081209_033325_981564_5949E34F)
References: <20081207110349.GA11803@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20081207110349.GA11803@gandalf.dynalias.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 07, 2008 at 03:03:49AM -0800, Norbert Preining wrote:
> Hi all,
>=20
> (please Cc)
>=20
> I am trying to compile compat-wireless for 2.6.28-rc7, but it bails o=
ut
> with:
>   CC [M]  /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.o
>   /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c: In functi=
on =E2=80=98ieee80211_handle_filtered_frame=E2=80=99:
>   /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c:449: error=
: =E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=
=E2=80=99
>   /src/wlan/compat-wireless-2008-12-06/net/mac80211/main.c:451: error=
: =E2=80=98struct sk_buff=E2=80=99 has no member named =E2=80=98requeue=
=E2=80=99
>   make[3]: *** [/src/wlan/compat-wireless-2008-12-06/net/mac80211/mai=
n.o] Error
>=20
>=20
> Is there a way to fix that? Thanks

Thanks for reporting it, its now fixed.
=20
  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
