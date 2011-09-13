Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53335 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab1IMTP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 15:15:27 -0400
Date: Tue, 13 Sep 2011 15:10:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Francis Moreau <francis.moro@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
Message-ID: <20110913191054.GI11772@tuxdriver.com> (sfid-20110913_211530_064380_E29678D6)
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
 <CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
 <20110913174444.GG11772@tuxdriver.com>
 <4E6FA480.5030500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E6FA480.5030500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 01:44:16PM -0500, Larry Finger wrote:
> On 09/13/2011 12:44 PM, John W. Linville wrote:
> >
> >We are going to have to find a way to get brcmsmac into the
> >wireless-next tree to make it feasible for the Broadcom guys to get
> >bcma support into that driver.  Do you agree?
> >
> >We could move it under the drivers/net/wireless tree.  Or, maybe I
> >could negotiate with Greg to keep it under the drivers/staging tree
> >but to let me manage it under wireless-next.  Or...?  Do you have
> >any thoughts on this?
> 
> Based on the earlier comments, I still see lots of problems in
> getting brcmsmac into the drivers/net/wireless tree; however, the
> solution where Greg lets you manage that part of drivers/staging
> does not seem to cause too many problems, as long as he is kept in
> the loop. If you could push those changes through Greg rather than
> DaveM, I don't think he would lose any control.

I don't think there is any reasonable way to push one tree through
two different upstream paths, unless both upstreams want all the tree
has to offer.  I don't see a way to both segregate brcmsmac commits
from the rest of the tree and yet have the bcma commits available
to brcmsmac.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
