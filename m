Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032Ab2GLPRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:17:13 -0400
Message-ID: <1342106232.4531.31.camel@jlt3.sipsolutions.net> (sfid-20120712_171719_653853_132B1DAB)
Subject: Re: [RFC] nl80211: Avoid checking for empty WoWLAN triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Jul 2012 17:17:12 +0200
In-Reply-To: <4FFEE9ED.6020906@qca.qualcomm.com>
References: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com>
	   <1341918365.4475.9.camel@jlt3.sipsolutions.net>
	   <4FFC0F22.6040906@qca.qualcomm.com>
	  <1341919201.4475.11.camel@jlt3.sipsolutions.net>
	  <4FFD1014.2000109@qca.qualcomm.com>
	 <1342103072.4531.26.camel@jlt3.sipsolutions.net>
	 <4FFEE9ED.6020906@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Maybe something like this would make sense then?
> >
> > http://p.sipsolutions.net/2aac79bcfe3a9b8b.txt
> 
> yeah this was the thing i am proposing
> http://www.spinics.net/lists/linux-wireless/msg94023.html
> 
> your patch is better optimized as it avoids a bool variable to check for 
> wow disable command, so this should be fine with the other iw
> patch to check for empty triggers ?
> http://www.spinics.net/lists/linux-wireless/msg94022.html

Well, my patch is different, it actually allows empty triggers to go
through as I had explained.

I'm just not sure which one makes more sense? I kinda feel that allowing
empty triggers might be a corner case but useful, while disallowing it
now would make it hard to ever support such a case?

johannes

