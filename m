Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43802 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423257AbXBHTRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 14:17:52 -0500
Date: Thu, 8 Feb 2007 19:17:21 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] wireless: add cfg80211
Message-ID: <20070208191721.GA32732@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com> <20070207004626.GA23096@tuxdriver.com> <20070207004747.GB23096@tuxdriver.com> <20070207073557.GA14703@infradead.org> <1170940377.4385.48.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1170940377.4385.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 08, 2007 at 02:12:57PM +0100, Johannes Berg wrote:
> > > +MODULE_AUTHOR("Johannes Berg");
> > > +MODULE_LICENSE("GPL");
> > 
> > Can you please add a MODULE_DESCRIPTION aswell?
> 
> Sure. Then again, didn't you just ask for "why can this be a module at
> all" too? :)

True.  Then again I try to stick MODULE_DESCRIPTIONS in wherever I can :)

