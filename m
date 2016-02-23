Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33571 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbcBWQPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 11:15:07 -0500
Message-ID: <1456244101.9910.21.camel@sipsolutions.net> (sfid-20160223_171518_567734_0CFC1B55)
Subject: Re: [PATCH 2/2] mac80211: add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 17:15:01 +0100
In-Reply-To: <56CC725D.1080209@openwrt.org>
References: <1455876110-12758-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1455876110-12758-2-git-send-email-janusz.dziedzic@tieto.com>
	 <1456237769.9910.20.camel@sipsolutions.net> <56CC725D.1080209@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 15:53 +0100, Felix Fietkau wrote:

> > Perhaps we could live with this being done only for the fast-xmit
> > case?
> I don't think we should pass padded vs non-padded frames depending on
> whether fast-xmit was used. The non-fast-xmit codepath could simply
> do the memmove at the end of the tx handlers though.

I guess that's fair. Would it be sufficent though?

johannes
