Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38122 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KAVG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 17:06:57 -0400
Received: by mail-ob0-f178.google.com with SMTP id wm4so5136108obc.9
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 14:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383314275-20960-55-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
	<1383314275-20960-55-git-send-email-mcgrof@do-not-panic.com>
Date: Fri, 1 Nov 2013 14:06:56 -0700
Message-ID: <CAMcMvsg8jim9qPZF2b6FaBgU0V8PygECJ+rS3vYWH26=nmzPGA@mail.gmail.com> (sfid-20131101_220704_056454_34A0D640)
Subject: Re: [PATCH 54/65] wireless-regdb: extend 5 GHz range for AR
From: Paul Stewart <pstew@chromium.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'd caution you to take a look at
http://www.productcompliancespecialists.eu/wp-content/uploads/2013/10/Regulatory_Update_Argentina_01-Oct-2013_Rev1.pdf

On Fri, Nov 1, 2013 at 6:57 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> Source is QCA's regulatory team's efforts.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---
>  db.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/db.txt b/db.txt
> index 10a7194..70b0b9d 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -46,7 +46,7 @@ country AR: DFS-FCC
>         (2402 - 2482 @ 40), (20)
>         (5170 - 5250 @ 80), (17)
>         (5250 - 5330 @ 80), (24), DFS
> -       (5490 - 5710 @ 80), (24), DFS
> +       (5490 - 5730 @ 80), (24), DFS
>         (5735 - 5835 @ 80), (30)
>
>  country AT: DFS-ETSI
> --
> 1.8.4.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
