Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48046 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1HLCdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:33:24 -0400
Received: by yxj19 with SMTP id 19so1714406yxj.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:33:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOp6jLbp_Fvf8u9CxdhsK0vqJTHvhean7qp+vumuM+S_3-PApA@mail.gmail.com>
References: <CAOp6jLa2xGcyg-rmE78FTpi11SbBq+EkWhXc+5na5QuebuFSBg@mail.gmail.com>
	<CAJ-Vmont2OdEGFqBKOen8XW+fTvA2xBgVr1h9vSeOBcQrE_FxA@mail.gmail.com>
	<CAOp6jLbp_Fvf8u9CxdhsK0vqJTHvhean7qp+vumuM+S_3-PApA@mail.gmail.com>
Date: Fri, 12 Aug 2011 10:33:23 +0800
Message-ID: <CAJ-Vmok7AjuUNPRqoL+ybm22UYjaPvJ4AjU4GXmzsxzZV1ZW5w@mail.gmail.com> (sfid-20110812_043327_913762_471ED2E5)
Subject: Re: [ath9k-devel] Packet loss regression with Atheros AR9280 adapter
From: Adrian Chadd <adrian@freebsd.org>
To: robert@ocallahan.org
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 August 2011 10:27, Robert O'Callahan <robert@ocallahan.org> wrote:

> Anything I can get building with this kernel, I guess. Any particular
> version I should try?

I'd suggest going back a month at a time
(http://www.orbit-lab.org/kernel/compat-wireless-2.6/2011/), try each
until you find one that works, then report "compat-wireless X works,
compat-wireless Y doesn't". That'll be a good way to test multiple
copies of the development wireless tree.

If someone Fedora-clued knows which version(s) of the wireless code
are involved with Robert's good and bad behaviour reports, that'll
also help.

Anything to kick-start a git bisect :-)

Ciao,


Adrian
