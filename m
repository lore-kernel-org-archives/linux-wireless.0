Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:55436 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbdJSXSm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 19:18:42 -0400
Received: by mail-pf0-f193.google.com with SMTP id 17so8207816pfn.12
        for <linux-wireless@vger.kernel.org>; Thu, 19 Oct 2017 16:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171019213834.23127-1-seth.forshee@canonical.com>
References: <20171019213834.23127-1-seth.forshee@canonical.com>
From: Ryan Mounce <ryan@mounce.com.au>
Date: Fri, 20 Oct 2017 09:48:25 +1030
Message-ID: <CAN+fvRZo6UtqDZN2Mhukx8EOiO+JcpSBvbM3RRka4kzscWjLDA@mail.gmail.com> (sfid-20171020_011845_863603_7336405A)
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Add 5 Ghz rules for
 Kazakhstan (KZ)
To: Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        =?UTF-8?B?0JDQvdC00YDQtdC5INCY0LLQsNC90L7Qsg==?= <wowz89@mail.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is missing the DFS domain, which is almost certainly DFS-ETSI as
KZ is in ITU region 1.

Regards,
Ryan Mounce

On 20 October 2017 at 08:08, Seth Forshee <seth.forshee@canonical.com> wrote:
> Add rules for 5150-5250 MHz, 5250-5350 MHz, and 5470-5725 Mhz
> based on the documents at [1] and [2].
>
> [1] http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
> [2] http://adilet.zan.kz/rus/docs/P000001379_
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  db.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/db.txt b/db.txt
> index e48f9a619651..96d8fda44284 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -689,8 +689,14 @@ country KY: DFS-FCC
>         (5490 - 5730 @ 160), (24), DFS
>         (5735 - 5835 @ 80), (30)
>
> +# Source:
> +# http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
> +# http://adilet.zan.kz/rus/docs/P000001379_
>  country KZ:
>         (2402 - 2482 @ 40), (20)
> +       (5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
> +       (5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
> +       (5470 - 5725 @ 80), (20), NO-OUTDOOR, DFS
>
>  country LB: DFS-FCC
>         (2402 - 2482 @ 40), (20)
> --
> 2.14.1
>
>
> _______________________________________________
> wireless-regdb mailing list
> wireless-regdb@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wireless-regdb
