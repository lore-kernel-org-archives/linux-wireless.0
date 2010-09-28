Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0I1HXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 03:23:35 -0400
Subject: Re: Given an interface, how to tell if it's associated?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CA12600.5070304@candelatech.com>
References: <4CA12600.5070304@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:23:33 +0200
Message-ID: <1285658613.3885.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 16:17 -0700, Ben Greear wrote:
> I need to iterate through all local->interfaces and
> if they are stations, figure out if they are associated
> or not.
> 
> I tried checking for existence of sdata->u.mgd.associated,
> but it is always null (I'm using non-encrypted links
> currently, in case that matters.)

That's correct, if it's always NULL then you're not associated properly
I guess?

johannes

