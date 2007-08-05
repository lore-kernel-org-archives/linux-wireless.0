Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:29772 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbXHEG6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 02:58:07 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1193279wxd
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2007 23:58:06 -0700 (PDT)
Message-ID: <1ba2fa240708042358x6b206c4bla6f10589fd2cf97f@mail.gmail.com>
Date: Sun, 5 Aug 2007 09:58:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: further plan wrt. monitor interfaces
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200708041322.14876.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1186178959.13315.30.camel@johannes.berg>
	 <200708041322.14876.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/4/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
> >  * FIF_PROMISC_IN_BSS (BSS filters still on, but otherwise promisc)
> >  * FIF_ALLMULTI               (all multicast frames are allowed through)
> >  * FIF_BROADCAST      (broadcast frames are allowed through)
> >  * FIF_FCSFAIL                (frames with bad FCS are allowed through)
> >  * FIF_PLCPFAIL               (frames with bad PLCP checksum are allowed through)
> >  * FIF_CONTROL                (control frames are shown)
> >  * FIF_OTHER_BSS      (frames from other BSSes are shown, subject to the
> >                        other filters)
> > [missing anything?]
>
> rt2x00 registers have the 2 following entries as well:
>
>         Physical error
>         Version error
>
>
> The rest of the idea looks pretty good, si I will be happy to implement it for rt2x00. :)
>
> Ivo
>
>
What about decryption error ?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
