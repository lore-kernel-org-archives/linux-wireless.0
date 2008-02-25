Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:51375 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYBYToI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:44:08 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1103571rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 11:44:06 -0800 (PST)
Subject: Re: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1203693709.7082.35.camel@johannes.berg>
References: <47be76f9.03b48c0a.025f.54f4@mx.google.com>
	 (sfid-20080222_071727_691746_9DC8AC76)  <1203693709.7082.35.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:45:45 -0800
Message-Id: <1203968745.6929.30.camel@localhost> (sfid-20080225_194425_608447_2EC81F79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 16:21 +0100, Johannes Berg wrote:
> >  - We no longer use directly rtnetlink for mesh peer link and mesh paths
> >    operation, and use nl80211 instead.
> 
> Nice too. What does libertas currently do btw?
> 

iwpriv...

> > I would like to point out that it looks like we can get duplicate sta_entries,
> > or more entries than the maximum allowed, if stas are added at the same time
> > through normal network behavior and manual operation through nl80211. Please
> > correct me if I am wrong or if it is just that no interface type is supposed to
> > allow both kinds of additions.
> 
> I think I CC'ed you on the patch fixing that, no?

Not sure which patch are you talking about, anyway I will check that
along with the mesh + sta_info changes testing.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


