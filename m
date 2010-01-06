Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:18686 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab0AFV3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 16:29:11 -0500
Received: by ey-out-2122.google.com with SMTP id 4so282889eyf.5
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 13:29:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B44FF56.6080204@lwfinger.net>
References: <op.u54a59c89lhzdc@linux-g0th.site>
	 <43e72e891001060926s320bf403ya2edf2601ced5125@mail.gmail.com>
	 <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com>
	 <op.u54ptmwm9lhzdc@linux-g0th.site> <4B44FF56.6080204@lwfinger.net>
Date: Wed, 6 Jan 2010 22:29:08 +0100
Message-ID: <b170af451001061329g7695fb57w859fd0a40729c2ef@mail.gmail.com>
Subject: Re: [PATCH 2/5] b43: N-PHY: add b43_nphy_get_tx_gains (V2)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 stycznia 2010 22:23 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 01/06/2010 02:57 PM, Rafał Miłecki wrote:
>> V2: adjust to renamed function, fill index array
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/phy_n.c |   81
>
> Just a little nitpick to save John some work, and to keep the patches straight.
>
> When you submit a second (or later) version of a patch, indicate the version in
> the mail header as in [PATCH 2/5 V2] b43:.... The upstream software strips all
> of that out and the commit header will be clean.
>
> In addition, it is useful to state what is different below the --- marker. The
> software also strips that part of the patch - the permanent commit message
> should be devoid of the details of the review message. It is like making
> sausage! Better that the details are hidden.

Uh, so once again I've made some mistake in my submitting. Sorry John,
thanks Larry.

I can excuse myself only with fact that it's something I've learn from
drm guys. Of course I'll change my ways. Ex.:


commit 3dfc63922f8edfa8774bf1ba882225c5f91b2220
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 22 10:06:49 2009 -0500

    drm/radeon/kms: add cvt mode if we only have lvds w/h and no edid (v4)

    This fixes LVDS on some mac laptops without a panel edid.

    v2 - Set proper mode type flags
    v3 - Note that this is not neceesarily the exact panel mode,
    but an approximation based on the cvt formula.  For these
    systems we should ideally read the mode info out of the
    registers or add a mode table, but this works and is much
    simpler.
    v4 - Update comments and debug message.

    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>


-- 
Rafał
