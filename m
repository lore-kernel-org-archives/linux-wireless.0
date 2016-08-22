Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50309 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbcHVQGK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 12:06:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Mishol\, Guy" <guym@ti.com>
Cc: "Pedersen\, Thomas" <twp@qca.qualcomm.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wlcore: mesh: add zone time sync support
References: <20160808085706.22668-1-guym@ti.com>
        <1471538527.3432.21.camel@qca.qualcomm.com>
        <874m6h5bex.fsf@purkki.adurom.net>
        <97207D90F0289D498537011312FCAD1138F55E66@DFRE01.ent.ti.com>
Date: Mon, 22 Aug 2016 18:56:01 +0300
In-Reply-To: <97207D90F0289D498537011312FCAD1138F55E66@DFRE01.ent.ti.com> (Guy
        Mishol's message of "Sun, 21 Aug 2016 10:13:22 +0000")
Message-ID: <87k2f8vlv2.fsf@kamboji.qca.qualcomm.com> (sfid-20160822_180811_590448_E0267B43)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Mishol, Guy" <guym@ti.com> writes:

> Kalle/Thomas,
> Thanks for your feedback.

Please don't top most, it makes using patchwork difficult and is
annoying to the readers.

> This time sync support is different from the one that mac80211
> maintains with mesh peers. This time sync is mostly used by upper
> layers for several applications (like audio). In this case we allow
> the user to configure for each zone who will be the synchronizer. You
> can refer to the following Application Report (chapter 6) for more
> information: http://www.ti.com/lit/an/swaa166/swaa166.pdf

I didn't fully understand what this does, but debugfs doesn't sound (no
pun intended) like a suitable interface for something like this. nl80211
is more likely candidate.

-- 
Kalle Valo
