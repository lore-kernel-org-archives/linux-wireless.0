Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:34997 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471AbZDIP24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 11:28:56 -0400
Message-ID: <49DE1428.3090902@lwfinger.net> (sfid-20090409_172900_230692_83E6500B)
Date: Thu, 09 Apr 2009 10:28:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix iwl3945 registration regression
References: <87ljqamktq.fsf@litku.valot.fi> <1239263762.32594.19.camel@johannes.local> <da94abde0904090720t3c9d5f88ta25b2b2bf71cba35@mail.gmail.com> <49DE0A4D.7010408@lwfinger.net> <20090409145714.GD3349@tuxdriver.com>
In-Reply-To: <20090409145714.GD3349@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> FWIW, I reverted the problem causing commit in the master branch
> of wireless-testing.  Hopefully the fix will be in -rc2 when
> wireless-testing gets there.

It should be. Rusty Russell has it in his tree already and the regression is
well known on LKML and to Rafael Wysocki.

Larry

