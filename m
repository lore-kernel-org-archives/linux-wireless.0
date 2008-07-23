Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59669 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbYGWBMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 21:12:31 -0400
Date: Tue, 22 Jul 2008 22:12:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [GIT PATCH] RFC: next batch of rfkill changes
Message-ID: <20080723011225.GA8831@khazad-dum.debian.net> (sfid-20080723_031233_910184_B2FAF18E)
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Jul 2008, Henrique de Moraes Holschuh wrote:
> This is my next batch of rfkill changes.  They add features and address
> some shortcomings of rfkill-input, mostly.
> 
> Please comment.  One thing that is bothering me in the last patch is
> what happens during suspend/resume to pending delayed rfkill state
> changes.  Are pending scheduled jobs executed, cancelled, or frozen to
> fire up when the system resumes itself?
> 
> Henrique de Moraes Holschuh (6):
>       rfkill: detect bogus double-registering
>       rfkill: add default global states
>       rfkill: add master_switch_mode functionality
>       rfkill: add EPO lock to rfkill-input
>       rfkill: rename rfkill_mutex to rfkill_global_mutex
>       rfkill: rate-limit rfkill-input workqueue usage

I forgot to give the -n option to git format-patch and didn't notice it
before I sent the batch away, so the ordering is missing.  The above
shortlog has the correct patch sequence.

Since this is just for comments, I will not resend the whole stack right
now just to get the ordering in the subject lines.

Sorry about that.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
