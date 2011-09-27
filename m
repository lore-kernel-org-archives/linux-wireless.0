Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51614 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1I0C0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 22:26:21 -0400
Received: by yib18 with SMTP id 18so4803478yib.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 19:26:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com>
References: <20110922154726.521122680@sipsolutions.net>
	<20110922154849.369194760@sipsolutions.net>
	<CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com>
Date: Tue, 27 Sep 2011 10:26:21 +0800
Message-ID: <CAJ-Vmo=9MUaKph=EXwF2VnE+=nHg4s=j=qhR2jnwa-xsXMno7g@mail.gmail.com> (sfid-20110927_042625_121516_7E40FF2F)
Subject: Re: [RFC 03/15] mac80211: also expire filtered frames
From: Adrian Chadd <adrian@freebsd.org>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 September 2011 06:30, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:

> No particular comments on the code yet but latency issues has got me
> thinking about the filtered frames stuff and if we really need it. How
> much benefit does keeping these frames give us instead of just
> dropping them?

Do you guys keep statistics about this sort of thing?

My macbook pro ends up causing my FreeBSD AP to miss TX'ing a lot of
frames, even if it's close by. This only occurs when it's on battery
power.

I have a feeling it's going to be doing aggressiveish power saving
stuff and this'll be fixed by me porting over and tidying up the
filtered frames support.


Adrian
