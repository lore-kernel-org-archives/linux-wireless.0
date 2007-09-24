Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50573 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629AbXIXNHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 09:07:19 -0400
Date: Mon, 24 Sep 2007 14:07:15 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: API to regulatory control (1)
Message-ID: <20070924130715.GA18847@infradead.org>
References: <1190456574.18521.220.camel@johannes.berg> <1190638775.21374.5.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190638775.21374.5.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 24, 2007 at 08:59:35AM -0400, Pavel Roskin wrote:
> On Sat, 2007-09-22 at 12:22 +0200, Johannes Berg wrote:
> 
> > struct ieee80211_channel {
> > 	/* first part set by driver */
> > 	u16 freq;		/* in MHz */
> > 	int hardware_value;	/* arbitrary */
> 
> Please consider using "long" for hardware_value.  Drivers should be able
> to use this value as a pointer to some driver-specific structure.

If you want to use it as pointer better make it a pointer..
