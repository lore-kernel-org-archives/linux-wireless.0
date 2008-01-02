Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:7765 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYABGcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 01:32:55 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3086828fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jan 2008 22:32:52 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Ivo Van Doorn" <ivdoorn@gmail.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Wed, 2 Jan 2008 06:32:31 +0000
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <87abnrz5lk.fsf@nokia.com> <a32f33a40712302356m46dfce7fu852636f8bc37b41f@mail.gmail.com>
In-Reply-To: <a32f33a40712302356m46dfce7fu852636f8bc37b41f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801020632.31361.chris2553@googlemail.com> (sfid-20080102_063300_722206_7014F53B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 31 December 2007, Ivo Van Doorn wrote:
> On Dec 31, 2007 8:27 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> > Ivo van Doorn <ivdoorn@gmail.com> writes:
> > > +             /*
> > > +              * Move entire frame 2 bytes to the front.
> > > +              */
> > > +             skb_push(skb, 2);
> > > +             memmove(skb->data, skb->data + 2, skb->len - 2);
> >
> > No skb_trim()? Shoudn't there be skb_trim(skb, 2) after memmove()?
>
> Good point, I completely forgot about that. :S
> Thanks. :)
>
> Ivo

Ah, does the patch I have applied and am running need enhancement, please?

Thanks

-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
