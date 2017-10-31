Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback14.m.smailru.net ([94.100.179.44]:51094 "EHLO
        fallback.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753718AbdJaRju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 13:39:50 -0400
Received: from [10.161.64.47] (port=58880 helo=smtp39.i.mail.ru)
        by fallback14.m.smailru.net with esmtp (envelope-from <wowz89@mail.ru>)
        id 1e9aVu-00086z-VS
        for linux-wireless@vger.kernel.org; Tue, 31 Oct 2017 20:39:47 +0300
Date: Tue, 31 Oct 2017 23:39:13 +0600
From: WoWz89 <wowz89@mail.ru>
Reply-To: =?windows-1251?B?yOLg7e7iIMDt5PDl6SDC6Ory7vDu4uj3?=
          <wowz89@mail.ru>
Message-ID: <493073613.20171031233913@mail.ru> (sfid-20171031_183954_109997_52C9BE8A)
To: Seth Forshee <seth.forshee@canonical.com>,
        wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless-regdb: Add 5 Ghz rules for Kazakhstan (KZ)
In-Reply-To: <20171020150651.32424-1-seth.forshee@canonical.com>
References: <20171020150651.32424-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=C7=E4=F0=E0=E2=F1=F2=E2=F3=E9=F2=E5, Seth.

=C2=FB =EF=E8=F1=E0=EB=E8 20 =EE=EA=F2=FF=E1=F0=FF 2017 =E3., 21:06:51:

> Add rules for 5150-5250 MHz, 5250-5350 MHz, and 5470-5725 Mhz
> based on the documents at [1] and [2].

> v2: Also add DFS region
Good afternoon, when will the update ?
> [1]
> http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_cha=
stot_no34.pdf
> [2] http://adilet.zan.kz/rus/docs/P000001379_

> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  db.txt | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

> diff --git a/db.txt b/db.txt
> index 9d129f2e542b..10c84ee1ca5d 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -691,8 +691,14 @@ country KY: DFS-FCC
>         (5490 - 5730 @ 160), (24), DFS
>         (5735 - 5835 @ 80), (30)
> =20
> -country KZ:
> +# Source:
> +#
> http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_cha=
stot_no34.pdf
> +# http://adilet.zan.kz/rus/docs/P000001379_
> +country KZ: DFS-ETSI
>         (2402 - 2482 @ 40), (20)
> +       (5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
> +       (5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
> +       (5470 - 5725 @ 80), (20), NO-OUTDOOR, DFS
> =20
>  country LB: DFS-FCC
>         (2402 - 2482 @ 40), (20)



--=20
=D1 =F3=E2=E0=E6=E5=ED=E8=E5=EC,
 WoWz89                          mailto:wowz89@mail.ru
