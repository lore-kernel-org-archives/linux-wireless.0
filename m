Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3GKIx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 04:53:27 -0400
Message-ID: <1373532803.8201.3.camel@jlt4.sipsolutions.net> (sfid-20130711_105330_121025_5084456D)
Subject: Re: [WT PATCH 3/6] wireless: Add memory usage debugging.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jul 2013 10:53:23 +0200
In-Reply-To: <1372546738-25827-3-git-send-email-greearb@candelatech.com> (sfid-20130630_005936_101807_5C11E16E)
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
	 <1372546738-25827-3-git-send-email-greearb@candelatech.com>
	 (sfid-20130630_005936_101807_5C11E16E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-06-29 at 15:58 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The bss objects are reference counted, and the ies
> are also tricky to keep track of.  Add module option to
> track allocation and freeing of the ies and bss objects,
> and add debugfs files to show the current objects.

I still think this is too intrusive, not in terms of runtime but code
maintenance penalty, so I'm not taking this.

johannes

