Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934071Ab3FSJtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 05:49:46 -0400
Message-ID: <1371635381.8349.9.camel@jlt4.sipsolutions.net> (sfid-20130619_114949_316461_898454E7)
Subject: Re: [PATCH 1/6] wireless:  Add memory usage debugging.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 11:49:41 +0200
In-Reply-To: <1371593017-10985-1-git-send-email-greearb@candelatech.com> (sfid-20130619_000356_212228_4AEA7C87)
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130619_000356_212228_4AEA7C87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 15:03 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The bss objects are reference counted, and the ies
> are also tricky to keep track of.  Add option to
> track allocation and freeing of the ies and bss objects,
> and add debugfs files to show the current objects.

I'm not really sure this is worth it -- you found the bug with
kmemleak() after all. Having very specific things for all of this
doesn't really seem worth it.

Either way though, I can't apply the patches since they won't apply. I
realize that you're working on 3.9, but you're going to have to send me
patches I can apply to one of my trees (and right now, not really
mac80211 but mac80211-next)

johannes

