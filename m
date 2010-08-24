Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0HXHuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 03:50:17 -0400
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
From: Johannes Berg <johannes@sipsolutions.net>
To: lance lassetter <lance@lass205.info>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1282611787.2446.7.camel@lass205.info>
References: <20100823110247.GA3198@infradead.org>
	 <1282572681.20674.3.camel@wwguy-ubuntu>
	 <20100823141432.GA29902@infradead.org>
	 <1282574533.12500.1.camel@wwguy-huron>
	 <20100823163259.GA15511@infradead.org>
	 <1282582845.13288.4.camel@wwguy-ubuntu>
	 <1282611787.2446.7.camel@lass205.info>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 09:51:48 +0200
Message-ID: <1282636308.3695.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-23 at 20:03 -0500, lance lassetter wrote:

> Don't know if this is related but upon resume of a tuxonice kernel from
> hibernation wireless is deauthenticated.  The router software runs 2.4
> linux kernel.   The dmesg output is:
> 
> [ 3372.060428] wlan0: deauthenticated from 68:7f:74:26:dd:2e (Reason: 7)
> [ 3372.065039] cfg80211: All devices are disconnected, going to restore
> regulatory settings
> [ 3372.065043] cfg80211: Restoring regulatory settings
> [ 3372.065047] cfg80211: Calling CRDA to update world regulatory domain

That's unrelated, and perfectly normal.

johannes

