Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43025 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1JIX1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Oct 2011 19:27:07 -0400
Received: by ywb5 with SMTP id 5so4893744ywb.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Oct 2011 16:27:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110092302.26965.chunkeey@googlemail.com>
References: <CAJ-VmomAP-LZdVkh1snpsTOxU18yPMxXut=KzjTwP+AkN9XidQ@mail.gmail.com>
	<201110092302.26965.chunkeey@googlemail.com>
Date: Mon, 10 Oct 2011 07:27:05 +0800
Message-ID: <CAJ-Vmo=tesMR98nwB0dc0Pai+Bs4mpEkkASLaz7i1phERLG=pQ@mail.gmail.com> (sfid-20111010_012711_271575_59688FFC)
Subject: Re: [patch] fix the definition of AR9170_PHY_REG_CURRENT_RSSI
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Felix <ic.felix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 October 2011 05:02, Christian Lamparter <chunkeey@googlemail.com> wrote:
> Hello again,
>
> I had some time to check what is on 0x043c.
> With AR9170 it looks like to be "0". This
> wouldn't be surprising, however the old reg
> 0x041c seems to jumps around a lot [as
> expected from the current rssi].
> Adrian, are you sure the source is accurate?

I'll have to double-check! I apologise in advance if it turns out this
isn't the case.

> Felix, do you know something about the
> CURRENT_RSSI register?

Thanks,


Adrian
