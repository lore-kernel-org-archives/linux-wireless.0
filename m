Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40661 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3GDRvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 13:51:49 -0400
Received: by mail-wi0-f169.google.com with SMTP id c10so7567666wiw.4
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jul 2013 10:51:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
	<1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com>
Date: Thu, 4 Jul 2013 10:51:48 -0700
Message-ID: <CAMcMvsiQb=byYEV4z2aZUYCLjRmqJUm_SQrUrOPUXrrfkcjeLA@mail.gmail.com> (sfid-20130704_195152_540700_6BD4E1F6)
Subject: Re: [RFC 42/53] wireless-regdb: ID, Indonesia - enable 5 GHz and VHT80
From: Paul Stewart <pstew@chromium.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: John Linville <linville@tuxdriver.com>,
	wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 3, 2013 at 6:04 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> Pursuant to:
>
> http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf,
>
> provide a 5GHz rule for Indonesian regulatory domain. QCA has
> also verified VHT80 can be enabled. Patch originally posted by
> Paul Stewart <pstew@chromium.org>, I just modified to enable 80 MHz
> bandwidth.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
>
> ---
>
>  db.txt |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/db.txt b/db.txt
> index 0ebb934..a101b1e 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -380,7 +380,9 @@ country HU: DFS-ETSI
>         (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
>
>  country ID:
> +       # ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
>         (2402 - 2482 @ 40), (N/A, 20)
> +       (5735 - 5815 @ 20), (N/A, 20)
>
>  country IE: DFS-ETSI
>         (2402 - 2482 @ 40), (N/A, 20)
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
