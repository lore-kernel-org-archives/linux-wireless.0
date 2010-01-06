Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:60555 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab0AFVXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 16:23:37 -0500
Received: by yxe26 with SMTP id 26so17060884yxe.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 13:23:37 -0800 (PST)
Message-ID: <4B44FF56.6080204@lwfinger.net>
Date: Wed, 06 Jan 2010 15:23:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 2/5] b43: N-PHY: add b43_nphy_get_tx_gains (V2)
References: <op.u54a59c89lhzdc@linux-g0th.site> <43e72e891001060926s320bf403ya2edf2601ced5125@mail.gmail.com> <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com> <op.u54ptmwm9lhzdc@linux-g0th.site>
In-Reply-To: <op.u54ptmwm9lhzdc@linux-g0th.site>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2010 02:57 PM, Rafał Miłecki wrote:
> V2: adjust to renamed function, fill index array
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_n.c |   81

Just a little nitpick to save John some work, and to keep the patches straight.

When you submit a second (or later) version of a patch, indicate the version in
the mail header as in [PATCH 2/5 V2] b43:.... The upstream software strips all
of that out and the commit header will be clean.

In addition, it is useful to state what is different below the --- marker. The
software also strips that part of the patch - the permanent commit message
should be devoid of the details of the review message. It is like making
sausage! Better that the details are hidden.

Larry

