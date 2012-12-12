Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2LLH1B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 02:27:01 -0500
Date: Wed, 12 Dec 2012 08:26:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix ibss scanning
Message-ID: <20121212072656.GA2253@redhat.com> (sfid-20121212_082706_250099_C1343E15)
References: <20121211094822.GA3262@redhat.com>
 <1355256114.9819.19.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1355256114.9819.19.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 11, 2012 at 09:01:54PM +0100, Johannes Berg wrote:
> On Tue, 2012-12-11 at 10:48 +0100, Stanislaw Gruszka wrote:
> > Do not scan on no-IBSS and disabled channels in IBSS mode. Doing this
> > can trigger Microcode errors on iwlwifi and iwlegacy drivers.
> 
> I guess this makes sense regardless of the microcode errors, applied.
> (Are you using SW scan?)

On iwlwifi error triggers with HW scan, on iwlegacy (3945) with SW
scan.

Thanks
Stanislaw
