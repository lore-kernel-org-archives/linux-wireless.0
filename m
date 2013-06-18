Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3FRJhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 05:37:14 -0400
Message-ID: <1371548225.8318.3.camel@jlt4.sipsolutions.net> (sfid-20130618_113717_888844_67B2D2CC)
Subject: Re: [PATCH] mac80211: allow key deletion for mesh interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Date: Tue, 18 Jun 2013 11:37:05 +0200
In-Reply-To: <1371548163.8318.2.camel@jlt4.sipsolutions.net> (sfid-20130618_113624_696931_05E0EB9D)
References: <CAEFj9864ioXkUy3Sg24k6vFTNR8ZfWj=to54J2VS=dvte+ExNA@mail.gmail.com>
	 <CAEFj987DCjNuv+W3oSq6ubHwjnkmKgKvcDThhP8s9ZXBsKmcjg@mail.gmail.com>
	 (sfid-20130618_110728_700495_DC4DE8F2) <1371548163.8318.2.camel@jlt4.sipsolutions.net>
	 (sfid-20130618_113624_696931_05E0EB9D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 11:36 +0200, Johannes Berg wrote:

> > Otherwise, it seems that we still manage to get sta pointer even the
> > bss is NULL.
> 
> What's the problem with that? But if this is a problem maybe we need to
> explicitly check for non-NULL?

I should pay attention ... we already check for non-NULL, so I don't
understand what you're trying to say at all.

Maybe you're looking at old code?

johannes

