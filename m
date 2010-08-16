Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab0HPTli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:41:38 -0400
Subject: Re: nl80211 scanning from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Christopher Piggott <cpiggott@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTiniqFJzrWFzNJTxsF31EZfSTei89dbS2Ak4YDjH@mail.gmail.com>
References: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
	 <1281986025.3683.31.camel@jlt3.sipsolutions.net>
	 <AANLkTiniqFJzrWFzNJTxsF31EZfSTei89dbS2Ak4YDjH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 21:41:36 +0200
Message-ID: <1281987696.3683.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[adding mailing list back]

On Mon, 2010-08-16 at 15:37 -0400, Christopher Piggott wrote:
> Thanks, I had missed that.  I assume I also have to specify the
> interface number for NL80211_CMD_GET_SCAN as well as
> NL80211_CMD_TRIGGER_SCAN, right?
> 
> What I get now is a "Success" on the TRIGGER but an "Operation not
> supported" on the GET.

Yes, but if that was the only thing missing you'd also get -EINVAL.
However, GET only supports dumping, you have to see how to do that,
which explains the -EOPNOTSUPP.

johannes

