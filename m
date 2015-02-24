Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38117 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbbBXKJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:09:49 -0500
Message-ID: <1424772587.2192.14.camel@sipsolutions.net> (sfid-20150224_110953_455053_0ABE8072)
Subject: Re: Connection issues with BW Tracking in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Feb 2015 11:09:47 +0100
In-Reply-To: <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com> (sfid-20150219_222859_339480_EFF9350E)
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
	 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
	 (sfid-20150219_222859_339480_EFF9350E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-20 at 02:58 +0530, Krishna Chaitanya wrote:

> Before that i have a basic question? Should we reset our tracking after
> the connection is lost, in my case above the connection was lost (Config
> change in A triggers a reboot), still mac80211 is tracking the BW changes?

Huh??

So the AP does restart, but mac80211 tries to stay connected to it? That
seems pretty unlikely. The tracking *shouldn't* have any knowledge of
what happened before the association, but there could be bugs in the
flags assignment I guess.

johannes

