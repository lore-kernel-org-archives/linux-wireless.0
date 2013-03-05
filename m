Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab3CES6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:58:08 -0500
Message-ID: <1362509883.8224.7.camel@jlt4.sipsolutions.net> (sfid-20130305_195812_288365_125ED13D)
Subject: Re: [PATCH v2 1/5] nl80211: explicit userspace MPM
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: johannes@sipsolution.net, linux-wireless@vger.kernel.org
Date: Tue, 05 Mar 2013 19:58:03 +0100
In-Reply-To: <1362431174-4747-1-git-send-email-thomas@cozybit.com> (sfid-20130304_220800_377626_F451D656)
References: <1362431174-4747-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130304_220800_377626_F451D656)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 13:06 -0800, Thomas Pedersen wrote:
> Secure mesh had the implicit requirement that the Mesh
> Peering Management entity be in userspace.  However
> userspace might want to implement an open MPM as well, so
> specify a mesh setup parameter to indicate this.

Applied all.

johannes

