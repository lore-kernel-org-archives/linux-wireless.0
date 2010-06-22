Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35584 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0FVVLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 17:11:37 -0400
Received: by pvh11 with SMTP id 11so577597pvh.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 14:11:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100622204048.5228.76910.stgit@mj.roinet.com>
References: <20100622204048.5228.76910.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Jun 2010 14:11:16 -0700
Message-ID: <AANLkTinf85gI-k4ojeCnZHjVAbXquDZ-al5sxSZTy2ud@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: "crap" code is "not yet posted", not
	"not yet merged"
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 22, 2010 at 1:40 PM, Pavel Roskin <proski@gnu.org> wrote:
>
> ---
>  scripts/admin-update.sh |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
> index 7592546..4eb7c3e 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -85,7 +85,7 @@ nag_pending() {
>
>  nag_crap() {
>        printf "${RED}%10s${NORMAL} - Crap changes not yet posted\n" $2
> -       printf "${RED}%10s${NORMAL} - Crap additions not yet merged\n" $3
> +       printf "${RED}%10s${NORMAL} - Crap additions not yet posted\n" $3
>        printf "${RED}%10s${NORMAL} - Crap deletions not yet posted\n" $4
>        printf "${RED}%10s${NORMAL} - %% of crap code\n" $(perl -e 'printf("%.4f", 100 * '$2' / '$1');')
>  }
>

applied, thanks!

  Luis
