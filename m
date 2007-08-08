Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60493
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427AbXHHXDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 19:03:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: arm allmodconfig
Date: Thu, 9 Aug 2007 01:03:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070808145705.756597b0.akpm@linux-foundation.org> <200708090038.05320.mb@bu3sch.de> <20070808155231.77bfc676.akpm@linux-foundation.org>
In-Reply-To: <20070808155231.77bfc676.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708090103.16295.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 August 2007 00:52:31 Andrew Morton wrote:
> > Ok, I have no problem with that. BUT my users and other people
> > in the kernel community do certainly have. Nobody will find
> > the bcm43xx option anymore, if we depend on SSB.
> > I mean, people do even seriously complain about the filenames
> > of the firmware and so on.
> > So adding a dep on SSB would generate about 3 to 4
> > bugreports each day, I'd say from experience.
> 
> yup, I understand the problem and I cannot suggest any acceptable solution,
> apart from...
> 
> > So, once you suggested that menuconfig should be changed to
> > show options "greyed out" when deps are not met. Are there
> > any patches available? Any starting point?
> 
> No, nothing at all, sorry.
> 
> I'm getting a _lot_ of build breakage out of SSB right now.

Ok, I will do some patch that converts all this to dependencies
and I will later look for a solution to the other problem
created by this.

-- 
Greetings Michael.
