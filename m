Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dot.nahmias.net ([64.71.168.40]:43903 "EHLO dot.nahmias.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZLWQtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 11:49:14 -0500
Date: Wed, 23 Dec 2009 16:21:11 +0000
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	562016-quiet@bugs.debian.org
Subject: Re: [RFC/T] cfg80211: fix race between deauth and assoc response
Message-ID: <20091223162111.GA902@nahmias.net>
References: <1261481565.22748.40.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1261481565.22748.40.camel@johannes.local>
From: joe@nahmias.net (Joseph Nahmias)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 12:32:45PM +0100, Johannes Berg wrote:
> I don't suppose you have a way of reproducing this issue? I know this
> patch will remove the warning, and I'm pretty sure it's correct too, but
> I can't really test this scenario.

Sorry, I've tried, but I cannot reproduce.

--Joe
