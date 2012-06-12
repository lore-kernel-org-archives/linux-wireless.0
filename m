Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab2FLKUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 06:20:30 -0400
Date: Tue, 12 Jun 2012 12:20:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Spinadel, David" <david.spinadel@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT] mac80211: stop connection monitor on dissassoc
Message-ID: <20120612102023.GB2612@redhat.com> (sfid-20120612_122032_613579_06F123D8)
References: <20120612095850.GA2612@redhat.com>
 <F781B6216F70FE49AB7B89F25E2F80C0187B2A@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <F781B6216F70FE49AB7B89F25E2F80C0187B2A@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

On Tue, Jun 12, 2012 at 10:05:52AM +0000, Spinadel, David wrote:
> This problem is not easy to reproduce.
> Attached my patch I just sent to Johannes, it seems to work here. 
> It basically the same change as yours, but I also removed stop_poll from ieee80211_sta_connection_lost().

Make sense. Johannes plese process with David patch.

Thanks
Stanislaw
