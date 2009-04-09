Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37284 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZDIPAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 11:00:50 -0400
Date: Thu, 9 Apr 2009 10:57:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix iwl3945 registration regression
Message-ID: <20090409145714.GD3349@tuxdriver.com> (sfid-20090409_170054_457746_A5C7D726)
References: <87ljqamktq.fsf@litku.valot.fi> <1239263762.32594.19.camel@johannes.local> <da94abde0904090720t3c9d5f88ta25b2b2bf71cba35@mail.gmail.com> <49DE0A4D.7010408@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49DE0A4D.7010408@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 09, 2009 at 09:46:37AM -0500, Larry Finger wrote:
> Kalle Valo wrote:

> > Maybe this is the infamous module loading bug I see people talking
> > about? I'll investigate it later.
> 
> Yes it is. The key is the "Failed to initialize wep", which is caused by a
> failure to load modules ecb and arc4. Apply that patch and all will be well.

FWIW, I reverted the problem causing commit in the master branch
of wireless-testing.  Hopefully the fix will be in -rc2 when
wireless-testing gets there.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
