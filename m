Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41456 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3FKTRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 15:17:07 -0400
Date: Tue, 11 Jun 2013 13:17:04 -0600
From: Jake Edge <jake@lwn.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT/RFC 0/4] iwlegacy: workaround for firmware frame tx
 rejection
Message-ID: <20130611131704.7e59efbb@chukar.edge2.net> (sfid-20130611_211710_894204_12A7492B)
In-Reply-To: <20130611160949.GA1696@redhat.com>
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
	<20130610143848.7afd5acc@chukar.edge2.net>
	<20130610214134.36085c4b@chukar.edge2.net>
	<20130611160949.GA1696@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Jun 2013 18:09:50 +0200 Stanislaw Gruszka wrote:

> I found a bug in one patch, perhaps it is a reason of failure.
> Please apply patch 5/4 from here:
> http://marc.info/?l=linux-wireless&m=136947199729148&q=raw 
> and patch from the end of this email, which fix the bug.
> 
> Could you also recheck that "mac80211: fix direct probe auth" patch
> is applied, note that it is included in 3.10-rc5 as commit
> 6211dd12da609bc6893b9c3182630b494737ec4b

yes, that mac80211 patch was applied to both 3.9 and 3.10-rc4 ... but I
just built 3.10-rc5 (and confirmed that it does have that patch) with
the 4 previous patches plus the new one above and my system connected
just fine ... i switched back and forth a few times and all seems
well ...

looks like a good a set of patches for 3.11, though I imagine stable
will stick with the other workaround ...

thanks!

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
