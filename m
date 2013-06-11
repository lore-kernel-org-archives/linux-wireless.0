Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3FKMRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:17:20 -0400
Message-ID: <1370953033.8356.32.camel@jlt4.sipsolutions.net> (sfid-20130611_141723_319374_8CB83AB3)
Subject: Re: [PATCH 1/2] {nl,cfg}80211: make peer link expiration time
 configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: Colleen Twitty <colleen@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 11 Jun 2013 14:17:13 +0200
In-Reply-To: <1370278420-10135-1-git-send-email-colleen@cozybit.com> (sfid-20130603_185351_276676_771F1CFB)
References: <1370278420-10135-1-git-send-email-colleen@cozybit.com>
	 (sfid-20130603_185351_276676_771F1CFB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-03 at 09:53 -0700, Colleen Twitty wrote:
> If a STA has a peer that it hasn't seen any tx activity
> from for a certain length of time, the peer link is
> expired. This means the inactive STA is removed from the
> list of peers and that STA is not considered a peer again
> unless it re-peers.  Previously, this inactivity time was
> always 30 minutes.  Now, add it to the mesh configuration
> and allow it to be configured.  Retain 30 minutes as a
> default value.

Applied both.

johannes

