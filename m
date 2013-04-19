Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34901 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3DSJcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 05:32:09 -0400
Received: by mail-ia0-f174.google.com with SMTP id m10so1298959iam.33
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 02:32:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366359232-31513-1-git-send-email-juhosg@openwrt.org>
References: <1366359232-31513-1-git-send-email-juhosg@openwrt.org>
Date: Fri, 19 Apr 2013 11:32:08 +0200
Message-ID: <CAL1gcdM_AcacVyYTrE0EiY5b3Pw7i3ZXadLGYZOsvJDLrOhdcA@mail.gmail.com> (sfid-20130419_113222_641720_BF58BC77)
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: rename
 rt2800_init_bbb_early to rt2800_init_bbp_early
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 19, 2013 at 10:13 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The function is used for BBP register initialization,
> fix the typo in the function name to reflect that.
>
> The patch contains no functional changes.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Thanks Gabor. Interesting that no-one has noticed this thus far.


---
Gertjan
