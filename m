Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab3EYGrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 02:47:48 -0400
Date: Sat, 25 May 2013 08:49:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jake Edge <jake@lwn.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT/RFC 0/4] iwlegacy: workaround for firmware frame tx
 rejection
Message-ID: <20130525064935.GA1599@redhat.com> (sfid-20130525_084753_359286_5367ECBC)
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
 <20130524171846.54f3d0be@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130524171846.54f3d0be@chukar.edge2.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 24, 2013 at 05:18:46PM -0600, Jake Edge wrote:
> On Thu, 23 May 2013 14:20:56 +0200 Stanislaw Gruszka wrote:
> > Jake, please test this set and check if it not cause association
> > problems you reported earlier this month.
> 
> I won't be able to get to this for 10 days or so ... I just got to
> Japan, so the AP in question is thousands of miles east :)

No problem, it doesn't have to be fast. I plan to post patches to
-next (i.e. 3.11), since we have simpler workaround already applied.

Thanks
Stanislaw 
