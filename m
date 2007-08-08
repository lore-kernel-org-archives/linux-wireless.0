Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758324AbXHHWxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:53:46 -0400
Date: Wed, 8 Aug 2007 15:52:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: arm allmodconfig
Message-Id: <20070808155231.77bfc676.akpm@linux-foundation.org>
In-Reply-To: <200708090038.05320.mb@bu3sch.de>
References: <20070808145705.756597b0.akpm@linux-foundation.org>
	<200708090013.06846.mb@bu3sch.de>
	<20070808152606.9ea3010f.akpm@linux-foundation.org>
	<200708090038.05320.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2007 00:38:05 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> > Just stop using select.   It's busted.
> 
> Ok, I have no problem with that. BUT my users and other people
> in the kernel community do certainly have. Nobody will find
> the bcm43xx option anymore, if we depend on SSB.
> I mean, people do even seriously complain about the filenames
> of the firmware and so on.
> So adding a dep on SSB would generate about 3 to 4
> bugreports each day, I'd say from experience.

yup, I understand the problem and I cannot suggest any acceptable solution,
apart from...

> So, once you suggested that menuconfig should be changed to
> show options "greyed out" when deps are not met. Are there
> any patches available? Any starting point?

No, nothing at all, sorry.

I'm getting a _lot_ of build breakage out of SSB right now.


I wonder if we could do something lame like adding some text to the
BCM_whatever Kconfig files, right there on the top-level menu entry which
says "go look at CONFIG_SSB".  Make it really obvious.

