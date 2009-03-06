Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44670 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZCFTp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 14:45:29 -0500
Date: Fri, 6 Mar 2009 14:42:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	mb@bu3sch.de
Subject: Re: [PATCH v2 0/3] cfg80211: send regulatory events
Message-ID: <20090306194243.GF3712@tuxdriver.com> (sfid-20090306_204532_992663_295BD9A8)
References: <1235690615-12109-1-git-send-email-lrodriguez@atheros.com> <43e72e890902261529k5b31537ctbb6426cd260154a7@mail.gmail.com> <43e72e890902261640j683e6131j7ec922f38874671d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890902261640j683e6131j7ec922f38874671d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 04:40:40PM -0800, Luis R. Rodriguez wrote:
> On Thu, Feb 26, 2009 at 3:29 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Thu, Feb 26, 2009 at 3:23 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> This series does the work to prep and then send regulatory
> >> events to userspace. This v2 keeps the country IE environment
> >> within cfg80211.h as we don't want to inform userspace about
> >> details of the country IE. We also now add the defines to help
> >> userspace determine when the kernel has the new command request
> >> and attributes.
> >
> > I forgot to mention this is also no longer based on top of Jouni's
> > MLME patch as that will be resent later so this can go in first.
> 
> Dah -- turns out NL80211_ATTR_REG_INTERSECT is not required as we
> already pass that on the alpha2. Will resend with that removed. So
> this now would only add one more attribute, the initiator.

Did I miss the resend?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
