Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:31016 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936443AbXG0X2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 19:28:50 -0400
Received: by wx-out-0506.google.com with SMTP id h31so887247wxd
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2007 16:28:50 -0700 (PDT)
Message-ID: <1ba2fa240707271628i38565d7bh3201959ffe269f3e@mail.gmail.com>
Date: Fri, 27 Jul 2007 16:28:49 -0700
From: "Tomas Winkler" <tomasw@gmail.com>
To: "hamsa Al Janoob" <mms82@hotmail.com>
Subject: Re: Linux wireless stack question
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY111-F35E30B3BF9450DAB091ED0B6F30@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <BAY111-F35E30B3BF9450DAB091ED0B6F30@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/27/07, hamsa Al Janoob <mms82@hotmail.com> wrote:
> Hi all,
>
> This question is directed to the authors (or any one with solid knowledge
> of) of the new ieee80211 (or mac80211) wireless stack, which can be found in
> Fedora 7 and expected to be part of the new kernel releases:
>
> Where is the exact location of the implementaiton of the binary exponential
> backoff procedure in the source code?
I'm speaking for mac80211 only, there is no such implementation. This
stuff is mostly done directly by hw or firmware.. I'm not familiar
with all the drivers though.
Also, where can I find the
> declarations of the min and max values of the contention window?
look for cw_max cw_min. It is brought to driver through conf_tx handler
Tomas
> Regards,
> Maali
>
>
Tomas _________________________________________________________________
> Express yourself instantly with MSN Messenger! Download today it's FREE!
> http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
