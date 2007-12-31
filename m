Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:1504 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbXLaH4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2007 02:56:18 -0500
Received: by rv-out-0910.google.com with SMTP id k20so4458601rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2007 23:56:18 -0800 (PST)
Message-ID: <a32f33a40712302356m46dfce7fu852636f8bc37b41f@mail.gmail.com> (sfid-20071231_075624_763026_99D33308)
Date: Mon, 31 Dec 2007 08:56:18 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Cc: chris2553@googlemail.com,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87abnrz5lk.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291614.55732.IvDoorn@gmail.com>
	 <200712301149.39388.chris2553@googlemail.com>
	 <200712301311.42895.IvDoorn@gmail.com> <87abnrz5lk.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 31, 2007 8:27 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Ivo van Doorn <ivdoorn@gmail.com> writes:
>
> > +             /*
> > +              * Move entire frame 2 bytes to the front.
> > +              */
> > +             skb_push(skb, 2);
> > +             memmove(skb->data, skb->data + 2, skb->len - 2);
>
> No skb_trim()? Shoudn't there be skb_trim(skb, 2) after memmove()?

Good point, I completely forgot about that. :S
Thanks. :)

Ivo
