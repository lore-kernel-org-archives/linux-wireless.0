Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2FLLBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 07:01:54 -0400
Message-ID: <1339498908.4531.0.camel@jlt3.sipsolutions.net> (sfid-20120612_130158_609842_3FCA5FCE)
Subject: Re: [RFC/RFT] mac80211: stop connection monitor on dissassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Spinadel, David" <david.spinadel@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 12 Jun 2012 13:01:48 +0200
In-Reply-To: <20120612102023.GB2612@redhat.com>
References: <20120612095850.GA2612@redhat.com>
	 <F781B6216F70FE49AB7B89F25E2F80C0187B2A@HASMSX103.ger.corp.intel.com>
	 <20120612102023.GB2612@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 12:20 +0200, Stanislaw Gruszka wrote:
> Hi.
> 
> On Tue, Jun 12, 2012 at 10:05:52AM +0000, Spinadel, David wrote:
> > This problem is not easy to reproduce.
> > Attached my patch I just sent to Johannes, it seems to work here. 
> > It basically the same change as yours, but I also removed stop_poll from ieee80211_sta_connection_lost().
> 
> Make sense. Johannes plese process with David patch.

Ok, will do. David, can you please submit it internally, I'll take it
from there.

johannes

