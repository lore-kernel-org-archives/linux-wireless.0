Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:37754 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965143AbXCLGJ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 02:09:58 -0400
Date: Mon, 12 Mar 2007 07:05:58 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [RFT] [PATCH] bcm43xx: ACI fixes
Message-ID: <20070312070558.07488359@localhost>
In-Reply-To: <45F4EA57.5010405@lwfinger.net>
References: <20070312010420.353a59c0@localhost>
	<45F4C902.9050405@lwfinger.net>
	<45F4EA57.5010405@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 12 Mar 2007 00:51:19 -0500
Larry Finger <larry.finger@lwfinger.net> wrote:

> Larry Finger wrote:
> > Stefano Brivio wrote:
> >> Please test the following patch. It syncs ACI (Adjacent Channels
> >> Interference) code to specs. I can't test it right now. Will port to
> >> mac80211 branch ASAP.
> >>
> >>
> >> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> >> ----
> > 
> > NACK - this patch really kills performance on my 4311. I'll see if I
> > can find the problem.
> 
> Forget the above. The performance was killed by my AP, which needed to be
> rebooted. I will send this patch on to John.

Well, wait. I'd want to see some performance improvements before the patch
is applied. That's why I didn't send it to John and put RFT in the
subject. Are there any?


--
Ciao
Stefano
