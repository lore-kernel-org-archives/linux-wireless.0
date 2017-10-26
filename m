Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback10.m.smailru.net ([94.100.178.50]:50275 "EHLO
        fallback.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932255AbdJZQSY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Oct 2017 12:18:24 -0400
Received: from [10.161.64.55] (port=40974 helo=smtp47.i.mail.ru)
        by fallback10.m.smailru.net with esmtp (envelope-from <wowz89@mail.ru>)
        id 1e7krN-0005mS-UR
        for linux-wireless@vger.kernel.org; Thu, 26 Oct 2017 19:18:22 +0300
Date: Thu, 26 Oct 2017 22:17:48 +0600
From: WoWz89 <wowz89@mail.ru>
Reply-To: =?windows-1251?B?yOLg7e7iIMDt5PDl6SDC6Ory7vDu4uj3?=
          <wowz89@mail.ru>
Message-ID: <1193154645.20171026221748@mail.ru> (sfid-20171026_181828_140628_D4E75F39)
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
Hello, you mean the patch for Kazakhstan is not forgotten ?
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
