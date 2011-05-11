Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45793 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1EKRQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 13:16:14 -0400
Date: Wed, 11 May 2011 13:12:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH V2 0/3] ssb/b43(legacy): clean dangling cores workarounds
Message-ID: <20110511171217.GF2490@tuxdriver.com> (sfid-20110511_191618_016160_666DF6FE)
References: <1304879433-7096-1-git-send-email-zajec5@gmail.com>
 <BANLkTimecZ0uB4V_b-8F784Tnbkqo71ORA@mail.gmail.com>
 <BANLkTinfMbkyh9kB+hsmka-JcWXAYEPynw@mail.gmail.com>
 <4DC9BC6E.2090804@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4DC9BC6E.2090804@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 10, 2011 at 05:30:06PM -0500, Larry Finger wrote:
> On 05/10/2011 05:08 PM, Rafał Miłecki wrote:
> >W dniu 8 maja 2011 19:54 użytkownik Rafał Miłecki<zajec5@gmail.com>  napisał:
> >>W dniu 8 maja 2011 20:30 użytkownik Rafał Miłecki<zajec5@gmail.com>  napisał:
> >>>There is no perfect place for this workarounds, but keeping it in ssb sounds
> >>>more reasonable.
> >>
> >>Uups, I didn't save edition fixing this grammatical mistake. I'm lucky
> >>it won't be visible anywhere in git log :)
> >
> >John: something went wrong there. You applied b43 and b43legacy
> >patches, but they should applied *after* ssb patch I don't see in your
> >tree.
> >
> >I don't know how many people can be affected by this... Can not tell
> >you if we should rebase or just commit ssb patch quickly.
> 
> My BCM4306 card is probably one of the few affected. No rebase will
> be needed as long as the ssb patch is available in 2.6.40-rc1.
> Fortunately, kernel building is not impacted.

Sorry, not sure what happened -- I'll go ahead and commit it.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
