Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:3307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbZDXOAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 10:00:38 -0400
Received: by fg-out-1718.google.com with SMTP id 16so184187fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 24 Apr 2009 07:00:37 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: add driver ops wrappers
References: <1240505572.30082.233.camel@johannes.local>
	<87y6tqd32q.fsf@litku.valot.fi>
	<1240565019.5066.2.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 24 Apr 2009 17:00:34 +0300
In-Reply-To: <1240565019.5066.2.camel@johannes.local> (Johannes Berg's message of "Fri\, 24 Apr 2009 11\:23\:39 +0200")
Message-ID: <878wlqb18d.fsf@litku.valot.fi> (sfid-20090424_160043_323147_EA5BF712)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-04-24 at 08:37 +0300, Kalle Valo wrote:
>
>> But I'm just concerned about the drv prefix, with very bad luck it might
>> create conflicts with some other component. What about using
>> ieee80211_drv, for example?
>
> Hmm. I kinda share your concern, but since these are all static inlines
> they don't really pollute any namespace, at least not for linking, so
> conflicts could only arise when another subsystem suddenly exports the
> same name, in a header file that we include. 

Yes. And the chances for this to happen are next to zero.

> In the end I decided not to worry about it just because it otherwise
> gets very long.

I agree now, this is fine as it is.

-- 
Kalle Valo
