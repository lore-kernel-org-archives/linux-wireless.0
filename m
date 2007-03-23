Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:60982 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751983AbXCWPYc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 11:24:32 -0400
Date: Fri, 23 Mar 2007 16:24:29 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] d80211: Set carrier status for STA interfaces
Message-ID: <20070323162429.503a8938@griffin.suse.cz>
In-Reply-To: <200703211408.58634.flamingice@sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
	<20070228203943.11473.36193.stgit@magic.sourmilk.net>
	<20070321182505.2260a9a8@griffin.suse.cz>
	<200703211408.58634.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 21 Mar 2007 14:08:51 -0400, Michael Wu wrote:
> On Wednesday 21 March 2007 13:25, Jiri Benc wrote:
> > Does this really work? Last time I checked, when the carrier is off, no
> > frames are sent to hard_start_xmit.
> >
> This applies only to STA interfaces, whose frames to the master dev are 
> dropped anyways if there is no association.

True, you're right.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
