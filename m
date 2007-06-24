Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48673 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753980AbXFXKqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 06:46:11 -0400
Date: Sun, 24 Jun 2007 12:46:05 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Andy Green <andy@warmcat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070624124605.7eaffb71@logostar.upir.cz>
In-Reply-To: <467E2DC0.30804@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	<20070621143558.68fc8e4a@griffin.suse.cz>
	<1182429920.21939.1.camel@johannes.berg>
	<20070621151441.500d62d5@griffin.suse.cz>
	<20070622154545.29eeebdb@griffin.suse.cz>
	<467BDCB1.1010604@warmcat.com>
	<1182526221.21939.94.camel@johannes.berg>
	<20070622174953.500817e0@griffin.suse.cz>
	<1182543620.21939.98.camel@johannes.berg>
	<467CB691.2090806@warmcat.com>
	<1182581630.21939.105.camel@johannes.berg>
	<20070623134451.643dd40c@logostar.upir.cz>
	<467D10BA.80104@warmcat.com>
	<1182635467.21939.125.camel@johannes.berg>
	<467E2DC0.30804@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 24 Jun 2007 09:39:28 +0100, Andy Green wrote:
> Anyway I don't want to argue myself out of an ACK ;-)  I think what I'll
> do is post a try #14 using encapsulation that works on wlan0 too but
> needs it associated, but on the understanding that try #13 is not
> deprecated if people prefer it.

Although that thing was my idea, I prefer #13. I think Johannes said that
too and given the fact that #14 is just a subset of #13 (regarding
functionality), you can save some time by not working on #14 ;-)

The only advantage of this would be not having monitor interface when using
tools like aircrack. But this is so specific usage that we don't care.

 Jiri

-- 
Jiri Benc
SUSE Labs
