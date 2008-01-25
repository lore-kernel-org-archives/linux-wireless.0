Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760398AbYAYV6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 16:58:35 -0500
Date: Fri, 25 Jan 2008 13:56:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
cc: Michael Buesch <mb@bu3sch.de>, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <20080125211815.GF14687@tuxdriver.com>
Message-ID: <alpine.LFD.1.00.0801251354350.5056@hp.linux-foundation.org> (sfid-20080125_215845_919271_D080B94C)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de>
 <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080125194807.GD14687@tuxdriver.com> <20080125195037.GE14687@tuxdriver.com> <20080125211815.GF14687@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, John W. Linville wrote:
> 
> Anyway, this is mostly just so we can scope the driver change required
> in absence of a firmware change.  Persumably the changes required if
> we were to put such code in mac80211 would be similar.

Make this conditional on archictures that need it, please.

And why is it suddenly smart to do this in three drivers rather than one 
upper layer?

		Linus
