Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37196 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737Ab3CZQ2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 12:28:12 -0400
Received: by mail-we0-f174.google.com with SMTP id u12so525866wey.33
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 09:28:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
	<CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
	<201303251712.19808.chunkeey@googlemail.com>
	<CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
	<CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
Date: Tue, 26 Mar 2013 09:28:09 -0700
Message-ID: <CAJ-Vmok8p9T0anY_1zGvArA5tZ4Fx4gdHHTVmSOGgprfNDqS+w@mail.gmail.com> (sfid-20130326_172818_622325_AB1DE733)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Robert Shade <robert.shade@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 March 2013 05:21, Robert Shade <robert.shade@gmail.com> wrote:
> I'll get a bug together, but I wanted to report that even with the
> patch above (fastcc disabled/cold reset always), it still eventually
> was unable to change the channel.  As soon as that failed, it's back
> into the state where it never seems to xmit anything in the data
> queues and can't associate.

Even after a cold reset?



adrian
