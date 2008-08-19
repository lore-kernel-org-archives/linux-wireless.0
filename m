Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39214 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYHSRjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 13:39:49 -0400
Date: Tue, 19 Aug 2008 20:38:42 +0300
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	'Ivo van Doorn' <ivdoorn@gmail.com>, hostap@lists.shmoo.com,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Message-ID: <20080819173842.GD4805@jm.kir.nu> (sfid-20080819_193955_254392_D9668119)
References: <000001c90168$703248e0$0b3ca8c0@gotws1589> <1219088136.2154.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1219088136.2154.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2008 at 03:35:36PM -0400, Dan Williams wrote:
> On Mon, 2008-08-18 at 21:27 +0200, Lars Ericsson wrote:
> > I have backported the patches to 0.5.9 and they works fine, as far as I can
> > tell on 2.6.26.
> > I can drop them here if they are of interest. I also vote for putting them
> > into 0.5.x 
> > 
> > Jouni; would that be possible ?

Sure. I'm usually merging all bug fixes from 0.6.x into the 0.5.x
releases.

> Jouni, if you like I could run through current git HEAD and identify
> some easy candidates for backporting to 0.5.x, and send the 0.6 commit
> ids to the hostap lists for you along with what needs to be done to
> backport the patch.

If the commit messages are clear, i.e., it is obvious that the changes
are bug fixes, I should be able to find these without problems. If there
is any unclarity on the status of the changes, a list could be helpful.

Whenever I'm preparing a new release from a stable branch, I will go
through the git tree and pick all changes that look like bug fixes (with
more filtering for 0.4.x and 0.3.x to only get critical fixes). With
that list, I'm going to be merging the changes in order into the stable
branch. I would expect that the changes discussed here would fall into
this process for automatic (well, with some manual labor ;-) inclusion
into 0.5.x.

-- 
Jouni Malinen                                            PGP id EFC895FA
