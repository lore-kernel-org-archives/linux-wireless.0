Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47474 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751131AbXEAKrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 06:47:36 -0400
Date: Tue, 1 May 2007 12:47:33 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: d80211: How does TX flow control work?
Message-ID: <20070501124733.47c45dd0@logostar.upir.cz>
In-Reply-To: <4637195E.5050907@web.de>
References: <459A5945.80909@web.de>
	<20070103185203.2754e059@griffin.suse.cz>
	<459BF179.6000906@web.de>
	<20070103191853.4f440b8b@griffin.suse.cz>
	<459BFB05.9040608@web.de>
	<45A03825.9080807@web.de>
	<45A2A728.1070404@web.de>
	<1175029130.5151.6.camel@johannes.berg>
	<460B7CAA.4020604@web.de>
	<4637195E.5050907@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 May 2007 12:41:34 +0200, Jan Kiszka wrote:
> Now I came across this issue once again. It is still present, I just
> observed it over the latest rt2x00 tree after updating shorewall and
> forgetting to fix its config.
> 
> I redirected tc to some logging filter, and this is what shorewall does
> when "CLEAR_TC=Yes" is set in shorewall.conf:
> 
> ...
> tc qdisc del dev wmaster0 root
> tc qdisc del dev wmaster0 ingress
> tc qdisc del dev wlan0 root
> tc qdisc del dev wlan0 ingress

Could you retest with the latest wireless-dev? It should be fixed there.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
