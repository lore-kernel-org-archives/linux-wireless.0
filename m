Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:21676 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbXBHSiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 13:38:03 -0500
Received: by wr-out-0506.google.com with SMTP id i21so587009wra
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2007 10:38:02 -0800 (PST)
Message-ID: <43e72e890702081038k1d4f226eocf28c5faf6b79dc5@mail.gmail.com>
Date: Thu, 8 Feb 2007 13:38:02 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1170940386.4385.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070207004626.GA23096@tuxdriver.com>
	 <20070207004747.GB23096@tuxdriver.com>
	 <20070207004832.GC23096@tuxdriver.com>
	 <20070207004929.GD23096@tuxdriver.com>
	 <20070207075420.GB14703@infradead.org>
	 <1170940386.4385.49.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-02-07 at 07:54 +0000, Christoph Hellwig wrote:
> > Btw, if we submit cfg80211 for inclusion there should be at least one patch
> > in the series actually converts a driver to use it.  Both to make this
> > code not dead and give people and example on how to use the cfg80211
> > infrastructure.
>
> I guess I could make softmac use it.

Another idea here is we can provide a configfs frontend to cfg80211
therefore any device which implements cfg80211 will automagically have
a userspace frontend (/configfs/wireless/foo) ready to test cfg80211.
With this we wouldn't have to wait for the next userspace nl80211
application to start testing cfg80211 directly (without wireless
extensions compat). A configfs frontend can also allow more rapid
development of userspace interfaces to configure wireless devices
through cfg80211. Comments?

  Luis
