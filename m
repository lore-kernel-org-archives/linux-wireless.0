Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38847 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbJLWXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 18:23:51 -0400
Received: by igkz10 with SMTP id z10so2175999igk.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2015 15:23:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444681930-25527-1-git-send-email-ola1olsson@gmail.com>
References: <1444681930-25527-1-git-send-email-ola1olsson@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 13 Oct 2015 09:23:30 +1100
Message-ID: <CAGRGNgUkpfDC2cXX9LFyOV7=9fydEKTgWF6rBQAEwzbN9Jy_Ew@mail.gmail.com> (sfid-20151013_002354_244791_8799F347)
Subject: Re: [PATCH] iw: Adding helpful hints for vendor cmd
To: Ola Olsson <ola1olsson@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ola,

On Tue, Oct 13, 2015 at 7:32 AM, Ola Olsson <ola1olsson@gmail.com> wrote:
> Without having access to the source, it was
> hard to know the format of vendor oui and sub
> cmd. This commit fixes that.
>
> Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
> ---
>  vendor.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/vendor.c b/vendor.c
> index d0b4f9e..86c03d1 100644
> --- a/vendor.c
> +++ b/vendor.c
> @@ -55,15 +55,19 @@ static int handle_vendor(struct nl80211_state *state,
>         FILE *file = NULL;
>
>         if (argc < 3)
> -               return -EINVAL;
> +               return 1;

You should probably explain why you're changing the return values in
the commit message.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
