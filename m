Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1314 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZCXWLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 18:11:30 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Date: Tue, 24 Mar 2009 17:09:12 -0500
Message-Id: <20090324220558.M48235@bobcopeland.com> (sfid-20090324_231134_724252_197E2AE3)
In-Reply-To: <20090324205847.GB29268@tesla>
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com> <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com> <200903242133.28405.chunkeey@web.de> <20090324205847.GB29268@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 Mar 2009 13:58:47 -0700, Luis R. Rodriguez wrote
> > > > pick up where Luis left off on the weekend.
> > Done! Patch attached, please add to the tree ;)
> 
> Nice....... so it seems all we need now is ath5k figured out and properly
> tested.

BTW there's a dumb bug in my first patch, missing 'break' in the switch
statements.  Oops.  But ath5k wasn't using any of that since it didn't
do the CTL stuff yet.  

I'll go ahead and rebase the stuff and repost it later in the week,
as long as you guys can test ath9k/ar9170 then I can do the debugging
for 5k..

-- 
Bob Copeland %% www.bobcopeland.com


