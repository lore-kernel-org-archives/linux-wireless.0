Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36968 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2LKXPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 18:15:20 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so17956lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 15:15:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355258172-6938-3-git-send-email-juhosg@openwrt.org>
References: <1355258172-6938-1-git-send-email-juhosg@openwrt.org> <1355258172-6938-3-git-send-email-juhosg@openwrt.org>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 11 Dec 2012 15:14:58 -0800
Message-ID: <CAB=NE6U+6+rLz+AXnrRe92skRWyFaTY9rrD4YF00caAwrNPsLg@mail.gmail.com> (sfid-20121212_001524_352054_DF18E622)
Subject: Re: [PATCH 3/3] qca-swiss-army-knife: automatically detect wide
 initval arrays
To: Gabor Juhos <juhosg@openwrt.org>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 11, 2012 at 12:36 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The number of the columns to be printed usually equals
> with the actual columns. The only exceptions are the
> Modes arrays, where the last column is not used by
> ath9k.
>
> The patch modifies the 'ath9k_get_p_columns' helper
> so that can determine the correct number of columns
> based on the name of the array. The the patch also
> removes the 'wide' argument of various functions
> because that is not necessary anymore. Additionaly,
> the superfluous INI_PRINTW macro is removed as well.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Thanks, applied and pushed all!

  Luis
