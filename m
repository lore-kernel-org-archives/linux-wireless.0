Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.iad.emailsrvr.com ([207.97.245.116]:40564 "EHLO
	smtp116.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXHEWfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 18:35:25 -0400
Message-ID: <46B65058.7030500@gentoo.org>
Date: Sun, 05 Aug 2007 18:34:00 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: further plan wrt. monitor interfaces
References: <1186178959.13315.30.camel@johannes.berg> <46B3B2AD.1040509@gentoo.org> <20070804074616.GA17144@deine-taler.de>
In-Reply-To: <20070804074616.GA17144@deine-taler.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ulrich Kunitz wrote:
> Just my 2 cents: I wonder, how you would handle the situation,
> that a device can support two MACs in parallel? 

I think that mac80211 would need quite a bit more work (in places like 
TX and RX path) to support devices with "multiple radios" (or 
pseudo-radios) anyway. Of course, I'm just speculating on how such 
hardware could/would operate. While we don't have any, I'm not sure it's 
worth increasing complexity so much to accommodate this.

Daniel

