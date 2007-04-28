Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34377 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753930AbXD1Ofa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 10:35:30 -0400
Date: Sat, 28 Apr 2007 16:35:27 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jkm@devicescape.com>
Subject: Re: [PATCH] mac80211: optimise ieee80211_get_hdrlen
Message-ID: <20070428163527.30375d03@logostar.upir.cz>
In-Reply-To: <1177768717.5102.11.camel@johannes.berg>
References: <1175011305.9282.10.camel@johannes.berg>
	<20070328191116.GJ6036@devicescape.com>
	<1177686617.3565.27.camel@johannes.berg>
	<20070428154049.313d5491@logostar.upir.cz>
	<1177768717.5102.11.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Apr 2007 15:58:37 +0200, Johannes Berg wrote:
> On Sat, 2007-04-28 at 15:40 +0200, Jiri Benc wrote:
> > This is not unlikely if you have a WDS link set up. I wouldn't change the
> > condition.
> 
> Good point. Want me to resend of do you want to just remove the
> unlikely?

Applied without the unlikely part.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
