Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:50947 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753768AbcHWJMg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 05:12:36 -0400
From: "Mishol, Guy" <guym@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "Pedersen, Thomas" <twp@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wlcore: mesh: add zone time sync support
Date: Tue, 23 Aug 2016 09:12:29 +0000
Message-ID: <97207D90F0289D498537011312FCAD1138F59CFA@DFRE01.ent.ti.com> (sfid-20160823_111241_197888_19F760A3)
References: <20160808085706.22668-1-guym@ti.com>
        <1471538527.3432.21.camel@qca.qualcomm.com>
        <874m6h5bex.fsf@purkki.adurom.net>
        <97207D90F0289D498537011312FCAD1138F55E66@DFRE01.ent.ti.com>
 <87k2f8vlv2.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k2f8vlv2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2016 at 18:56:01, Kalle Valo wrote:
> Subject: Re: [PATCH] wlcore: mesh: add zone time sync support
> 
> "Mishol, Guy" <guym@ti.com> writes:
> 
> > Kalle/Thomas,
> > Thanks for your feedback.
> 
> Please don't top most, it makes using patchwork difficult and is 
> annoying to the readers.

OK. Understood.

> > This time sync support is different from the one that mac80211 
> > maintains with mesh peers. This time sync is mostly used by upper 
> > layers for several applications (like audio). In this case we allow 
> > the user to configure for each zone who will be the synchronizer. 
> > You can refer to the following Application Report (chapter 6) for 
> > more
> > information: http://www.ti.com/lit/an/swaa166/swaa166.pdf
> 
> I didn't fully understand what this does, but debugfs doesn't sound 
> (no pun
> intended) like a suitable interface for something like this. nl80211 
> is more likely candidate.

Agree. The debugfs part was mainly meant for demo and can be omitted. I will submit instead a different patch that only adds the necessary APIs in the wlcore.

Guy
