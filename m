Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1JVRoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 13:44:22 -0400
Subject: Re: [PATCH 1/4] nl80211: Add probe response offload attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAA03845twSZjJHN-MygjLvK8VsQk+_S6qNqdM7JgZA9GS9LPWQ@mail.gmail.com> (sfid-20111022_194251_250668_CCEB8E51)
References: <1319289112-21896-1-git-send-email-guy@wizery.com>
	 <1319290457.3956.3.camel@jlt3.sipsolutions.net>
	 <1319290618.3956.6.camel@jlt3.sipsolutions.net>
	 <CAA038468Y7T4BSAycqmNc0q+Ph1wSh07B57tV--O00kvDEp-wg@mail.gmail.com>
	 <1319305186.3956.11.camel@jlt3.sipsolutions.net>
	 <CAA03845twSZjJHN-MygjLvK8VsQk+_S6qNqdM7JgZA9GS9LPWQ@mail.gmail.com>
	 (sfid-20111022_194251_250668_CCEB8E51)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Oct 2011 19:44:18 +0200
Message-ID: <1319305458.3956.12.camel@jlt3.sipsolutions.net> (sfid-20111022_194424_551359_6ACBF921)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-22 at 19:42 +0200, Guy Eilam wrote:

> > Yeah but if you add a wiphy flag and the bits into struct wiphy, then
> > you can save the function pointer which seems nicer?
> 
> You're absolutely right.
> I'll send another version of the patch that will have a flag and
> bitmap in the wiphy struct.

Also I believe that means you don't need patch 2 at all so that's kinda
nice :-)

johannes

