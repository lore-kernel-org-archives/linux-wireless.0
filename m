Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51908 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab3CYQM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 12:12:27 -0400
Received: by mail-bk0-f42.google.com with SMTP id jc3so382336bkc.15
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 09:12:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: Auth Packet TX Delay
Date: Mon, 25 Mar 2013 17:12:19 +0100
Cc: Robert Shade <robert.shade@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com> <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com> <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201303251712.19808.chunkeey@googlemail.com> (sfid-20130325_171231_324633_1AAB4AF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 25, 2013 03:23:53 AM Adrian Chadd wrote:
> Also, would you please make sure you file a bugzilla.kernel.org ticket
> so this gets tracked?
>
> It's good to know that some combination of fast channel change and
> warm versus cold reset is making things better/worse.
> 
> And although a cold reset is likely a good thing to _fix_ the problem,
> it still leaves the underlying DMA/PHY hangs unresolved.
> 
> But yes, please file a bugzilla ticket so this gets tracked right!
Um, do you want a bugreport for ath9k or carl9170 or for both?

Regards,
	Christian
