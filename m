Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:40796 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYAMWND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 17:13:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: remove unused variable
Date: Sun, 13 Jan 2008 23:11:50 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080113194834.677af663@morte> <20080113201653.2c36391e@morte> <200801132248.47860.IvDoorn@gmail.com>
In-Reply-To: <200801132248.47860.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801132311.50316.mb@bu3sch.de> (sfid-20080113_221315_714237_7981FBFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 January 2008 22:48:47 Ivo van Doorn wrote:
> Hi.
> 
> > > > Remove an unused variable that caused a warning while building. Please note
> > > > that the pipe obtained there isn't used anywhere else.
> > > 
> > > This patch is in wireless-2.6 already...
> > 
> > Actually, I thought I already sent this patch, but couldn't find it
> > anywhere, neither in my outbox nor in git-log. Could you tell me what's the
> > related SHA commit? Thanks.
> 
> This is in my rt2x00.git log. It is signed off by John and not by me,
> so that means it didn't go through rt2x00.git to get into the wireless tree.
> I have merged the patch into rt2x00.git during my last clone from wireless...
> 
> commit 01b0258008a73648245dcbc628ff948878c428e0
> Author: Stefano Brivio <stefano.brivio@polimi.it>
> Date:   Wed Dec 19 01:43:33 2007 +0100
> 
>     rt2x00: remove unused variable
> 
>     Remove an unused variable. Note that the pipe obtained there isn't used as
>     well.
> 
>     Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

I cannot find this commit in wireless-2.6

-- 
Greetings Michael.
