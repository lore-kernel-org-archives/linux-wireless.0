Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2GEHpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 03:45:09 -0400
Message-ID: <1341474303.4455.5.camel@jlt3.sipsolutions.net> (sfid-20120705_094514_183363_51B22140)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Date: Thu, 05 Jul 2012 09:45:03 +0200
In-Reply-To: <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com> (sfid-20120704_182641_310085_58E16943)
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341394944.4482.9.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
	 (sfid-20120704_182641_310085_58E16943)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 09:26 -0700, Luis R. Rodriguez wrote:
> I've skipped the other comments as I can address those in a new series.
> 
> On Wed, Jul 4, 2012 at 2:42 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > So I'm not really convinced about this. It seems this Kconfig should
> > better be a Kconfig that enables other Kconfig only, not enabling other
> > features. How else would anyone be able to do due diligence and check
> > what exactly this enables that they need to test?
> 
> Makes sense, so would we then have CONFIG_REG_HINT_CELL_BASE_STATION ?

I don't know how fine-grained it should be? Maybe it should be more
generic and be a config for all (future) kinds of user hints?

johannes

