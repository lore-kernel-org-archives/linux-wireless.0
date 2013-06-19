Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:55918 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab3FSCwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 22:52:00 -0400
Received: by mail-qa0-f44.google.com with SMTP id j8so142186qah.17
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 19:51:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371593017-10985-6-git-send-email-greearb@candelatech.com>
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com> <1371593017-10985-6-git-send-email-greearb@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 19 Jun 2013 12:51:38 +1000
Message-ID: <CAGRGNgUUkVdes-QEz6n1nrvdgXwSb4cUKryPv9e1gZqgouhBhA@mail.gmail.com> (sfid-20130619_045203_430693_337122DC)
Subject: Re: [PATCH 6/6] wireless: Add comments about bss refcounting.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Wed, Jun 19, 2013 at 8:03 AM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Should help the next person that tries to understand
> the bss refcounting logic.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  net/wireless/scan.c |    4 ++++
>  net/wireless/sme.c  |    3 +++
>  2 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 542ff6d..834d2f9 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -622,6 +622,7 @@ static int cmp_bss(struct cfg80211_bss *a,
>         }
>  }
>
> +/** Returned bss is reference counted and must be cleaned up appropriately. */

/** is for kernel doc, I'm not sure that is valid kernel doc.

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
