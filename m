Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47340 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1DUAah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 20:30:37 -0400
Date: Wed, 20 Apr 2011 20:18:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2011-04-20
Message-ID: <20110421001836.GB2437@tuxdriver.com>
References: <20110420170432.GA2301@joana>
 <20110420202015.GA2311@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110420202015.GA2311@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 20, 2011 at 05:20:15PM -0300, Gustavo F. Padovan wrote:
> Hi John,
> 
> * Gustavo F. Padovan <padovan@profusion.mobi> [2011-04-20 14:04:32 -0300]:
> 
> > Hi John,
> > 
> > Four small fixes for 2.6.39. An incorrect refcnt balance for hci connection by
> > Ville Tervo, a warning fix in the command timer by Vinicius Gomes, an ERTM
> > fix by Ruiyi Zhang, and SCO synchronization fix by Luiz Augusto von Dentz.
> > 
> > Please pull or let me know any problems. Thanks.
> 
> Hold on with the pull! I've found a merge conflict with -next. (I tested the
> merge with --dry-run, but it doesn't check for check conflicts). I'll do the
> right thing now and send a new pull request to you soon. 
> 
> Regards,
> 
> -- 
> Gustavo F. Padovan
> http://profusion.mobi

FWIW, I already did the pull into wireless-2.6 and pushed it out
for some soak time.  If there is a merge conflict with -next, then
please let me know how to fix it and I'll pull wireless-2.6 into
wireless-next-2.6 as soon as possible to eliminate the conflict.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
