Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:58128 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0CEDy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 22:54:28 -0500
Received: by iwn5 with SMTP id 5so2381848iwn.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 19:54:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267760678-5421-4-git-send-email-lrodriguez@atheros.com>
References: <1267760678-5421-1-git-send-email-lrodriguez@atheros.com>
	<1267760678-5421-4-git-send-email-lrodriguez@atheros.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 5 Mar 2010 14:54:07 +1100
Message-ID: <646765f41003041954r6b11813al41248117dd383584@mail.gmail.com>
Subject: Re: [RFC 3/3] ath9k: rename initvals.h to ar9200_initvals.h
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kevin@atheros.com, doug.dahlby@atheros.com,
	cliff.holden@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 5, 2010 at 14:44, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> The register initialization values we have so far are
> only for the AR5008, AR9002 and AR9002 hardware families
> and we've managed to get ar90002_hw.c to be its only user
> so clarify this by renaming the initvals.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    2 +-
>  .../ath/ath9k/{initvals.h => ar9200_initvals.h}    |    0
>  2 files changed, 1 insertions(+), 1 deletions(-)
>  rename drivers/net/wireless/ath/ath9k/{initvals.h => ar9200_initvals.h} (100%)

Should this possibly be ar9002_initvals.h as to match up with ar9002_hw.c?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
