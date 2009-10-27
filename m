Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:49989 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbZJ0QNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:13:21 -0400
Received: by iwn8 with SMTP id 8so235021iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 09:13:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256658827-25940-1-git-send-email-lrodriguez@atheros.com>
References: <1256658827-25940-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 27 Oct 2009 09:13:03 -0700
Message-ID: <43e72e890910270913u540d84fcy15ab7e1fbafb67a@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] wireless-regdb: update US rules for 5600
	MHz - 5650 MHz
To: linville@tuxdriver.com
Cc: Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2009 at 8:53 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> The FCC is trying to assist airports that use Terminal Doppler
> Weather Radar (TDWR) systems in avoiding interference with
> some outdoor wireless systems operating in the 5.4 GHz
> (5470 MHz - 5725 MHz) band. One of the things they have decided
> on is to disallow operation on the 5600 MHz - 5650 MHz frequency
> range inclusive. What this means in practice is 5 GHz 802.11
> devices programmed to operate in the US will have these
> channels now disabled:
>
>  * 5600 MHz [120] (disabled)
>  * 5620 MHz [124] (disabled)
>  * 5640 MHz [128] (disabled)
>  * 5660 MHz [132] (disabled)
>
> This is documented on the FCC Knowledge based Publication
> Number: 443999 [1]
>
> [1] https://fjallfoss.fcc.gov/oetcf/kdb/forms/FTSSearchResultPage.cfm?switch=P&id=41732
>
> Cc: Michael Green <Michael.Green@atheros.com>
> Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
> Cc: David Quan <David.Quan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  db.txt |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index 84be443..c8b1ef0 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -562,7 +562,8 @@ country US:
>        (2402 - 2472 @ 40), (3, 27)
>        (5170 - 5250 @ 40), (3, 17)
>        (5250 - 5330 @ 40), (3, 20), DFS
> -       (5490 - 5710 @ 40), (3, 20), DFS
> +       (5490 - 5600 @ 40), (3, 20), DFS
> +       (5651 - 5710 @ 40), (3, 20), DFS

Dah that should be 5650, will send v2.

  Luis
