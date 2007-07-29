Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc2-s11.bay0.hotmail.com ([65.54.246.147]:30093 "EHLO
	bay0-omc2-s11.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762439AbXG2OVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 10:21:55 -0400
Message-ID: <BAY111-F325FAED32F3D133BCD0C69B6ED0@phx.gbl>
In-Reply-To: <1ba2fa240707271628i38565d7bh3201959ffe269f3e@mail.gmail.com>
From: "maali Al Janoob" <mms82@hotmail.com>
To: tomasw@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: Linux wireless stack question
Date: Sun, 29 Jul 2007 18:21:50 +0400
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for the reply.
What I want to do basically is changing the backoff algorithm to implement a 
modified protocol in Linux (for my thesis). From what I know, the firmware 
is inaccessible. Are you aware of any available source code for a firmware 
of any driver?

Please, I need this help so badly to continue my thesis work, any ideas?

Thanks,
Maali


>From: "Tomas Winkler" <tomasw@gmail.com>
>To: "hamsa Al Janoob" <mms82@hotmail.com>
>CC: linux-wireless@vger.kernel.org
>Subject: Re: Linux wireless stack question
>Date: Fri, 27 Jul 2007 16:28:49 -0700
>
>On 7/27/07, hamsa Al Janoob <mms82@hotmail.com> wrote:
> > Hi all,
> >
> > This question is directed to the authors (or any one with solid 
>knowledge
> > of) of the new ieee80211 (or mac80211) wireless stack, which can be 
>found in
> > Fedora 7 and expected to be part of the new kernel releases:
> >
> > Where is the exact location of the implementaiton of the binary 
>exponential
> > backoff procedure in the source code?
>I'm speaking for mac80211 only, there is no such implementation. This
>stuff is mostly done directly by hw or firmware.. I'm not familiar
>with all the drivers though.
>Also, where can I find the
> > declarations of the min and max values of the contention window?
>look for cw_max cw_min. It is brought to driver through conf_tx handler
>Tomas
> > Regards,
> > Maali
> >
> >
>Tomas _________________________________________________________________
> > Express yourself instantly with MSN Messenger! Download today it's FREE!
> > http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
>linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>-
>To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Don't just search. Find. Check out the new MSN Search! 
http://search.msn.com/

