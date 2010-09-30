Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab0I3WjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:39:03 -0400
Subject: Re: [RFC 0/2] generic netlink doit generalisation
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, tgraf@suug.ch
In-Reply-To: <20100930211013.472957770@sipsolutions.net>
References: <20100930211013.472957770@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 00:39:38 +0200
Message-ID: <1285886378.5137.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 23:10 +0200, Johannes Berg wrote:
> nl80211 does a lot of boilerplate work
> for each generic netlink doit() operation,
> this is an attempt to reduce it.

Here are the completed versions of the nl80211 cleanups:

http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-nl80211-use-pre-post.patch
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-nl80211-generic-running.patch

The combined diffstat of these two is

 net/wireless/nl80211.c | 1756 +++++++++++++++----------------------------------
 1 file changed, 541 insertions(+), 1215 deletions(-)

and they reduce code size by >4k on my x86_64 compile.

johannes

