Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:1052 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYAMWas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 17:30:48 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2018814fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 14:30:47 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: remove unused variable
Date: Sun, 13 Jan 2008 23:30:39 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <20080113194834.677af663@morte> <200801132248.47860.IvDoorn@gmail.com> <200801132311.50316.mb@bu3sch.de>
In-Reply-To: <200801132311.50316.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801132330.39343.IvDoorn@gmail.com> (sfid-20080113_223055_199207_5FA896B6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 January 2008, Michael Buesch wrote:
> On Sunday 13 January 2008 22:48:47 Ivo van Doorn wrote:
> > Hi.
> > 
> > > > > Remove an unused variable that caused a warning while building. Please note
> > > > > that the pipe obtained there isn't used anywhere else.
> > > > 
> > > > This patch is in wireless-2.6 already...
> > > 
> > > Actually, I thought I already sent this patch, but couldn't find it
> > > anywhere, neither in my outbox nor in git-log. Could you tell me what's the
> > > related SHA commit? Thanks.
> > 
> > This is in my rt2x00.git log. It is signed off by John and not by me,
> > so that means it didn't go through rt2x00.git to get into the wireless tree.
> > I have merged the patch into rt2x00.git during my last clone from wireless...
> > 
> > commit 01b0258008a73648245dcbc628ff948878c428e0
> > Author: Stefano Brivio <stefano.brivio@polimi.it>
> > Date:   Wed Dec 19 01:43:33 2007 +0100
> > 
> >     rt2x00: remove unused variable
> > 
> >     Remove an unused variable. Note that the pipe obtained there isn't used as
> >     well.
> > 
> >     Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> >     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> I cannot find this commit in wireless-2.6

Strange, git is pulling tricks of some kind. I have the patch in 3 branches of rt2x00.git,
master, wireless and upstream. This means it was pulled in from the everything branch
on wireless-2.6. So apparently during the rebasing in wireless the patch has disappeared
or something. :S

John, can you apply the patch to wireless? Otherwise I'll apply it to rt2x00.git later
this week when I rebase everything against the latest wireless git repository (which
would remove the old patch from my tree, so I can apply it without conflicts).

Ivo
