Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789Ab2LGJum (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 04:50:42 -0500
Date: Fri, 7 Dec 2012 10:50:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
Message-ID: <20121207095012.GB11933@redhat.com> (sfid-20121207_105045_326679_34B91055)
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com>
 <87a9ts4c1q.fsf@nemi.mork.no>
 <50BF8C18.9060504@candelatech.com>
 <20121206122528.GG2502@redhat.com>
 <50C0FCE0.2090507@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50C0FCE0.2090507@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 06, 2012 at 12:15:28PM -0800, Ben Greear wrote:
> I don't have time to work on this today...maybe not tomorrow either.
> 
> So, if someone else feels like fixing it, please feel free.

Ok, I'll try to fix that. However this could require modification
of all cfg80211 drivers, so could not be fast.

Stanislaw
