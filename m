Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:54072 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbXHaQnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 12:43:21 -0400
Received: by py-out-1112.google.com with SMTP id u77so3561967pyb
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2007 09:43:21 -0700 (PDT)
Message-ID: <43e72e890708310943x55c10044t26e6f8e16292247c@mail.gmail.com>
Date: Fri, 31 Aug 2007 12:43:20 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k - License clarification
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	"Matt Norwood" <norwood@softwarefreedom.org>,
	"Richard Fontana" <fontana@softwarefreedom.org>,
	"karen sandler" <karen@softwarefreedom.org>,
	"Reyk Floeter" <reyk@openbsd.org>, "Sam Leffler" <sam@errno.com>,
	"David Kimdon" <dwhedon@devicescape.com>
In-Reply-To: <43e72e890708310918l100326a6n6fa0c6642f4a52d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890708310918l100326a6n6fa0c6642f4a52d4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding some other copyright holders to the CC list

  Luis

On 8/31/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Attached patch amends the ath5k license as per review from SFLC with
> the following changes:
>
>   * Makes sure that Reyk's copyright and license notice appears
>     correctly in each file that was derived from his work.
>
>   * Makes sure that Jiri's changes were released under a permissive,
>     modified-BSD license, as he indicated that was his preference.
>
>   * Makes sure that Nick's changes were released under
>     GPLv2-or-later, as he indicated that was his preference.
>
>   * Makes sure that all files clearly have the any GPL notices on
>     top, but include the proper BSD-like notices below when required.
>
>    * Adds Devicescape attribution to ath5k_base.c
>
>   * Sets the MODULE_LICENSE to GPL, because with Nick's changes
>     included under only GPL, the module can only be available under GPL.
>
>   * Adds Nick to the list of MODULE_AUTHORs because his changes
>     are substantial.
>
> Signed-Off-By: Bradley M. Kuhn <bkuhn@softwarefreedom.org>
> Signed-Off-By: Matt Norwood <norwood@softwarefreedom.org>
> Signed-Off-By: Richard Fontana <fontana@softwarefreedom.org>
> Signed-Off-By: Karen Sandler <karen@softwarefreedom.org>
>
> Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
> Acked-by: Jiri Slaby <jirislaby@gmail.com>
> Acked-by: Nick Kossifidis <mickflemm@gmail.com>
>
> Thanks to the SFLC for their help with this driver from legal hell.
>
>   Luis
>
>
