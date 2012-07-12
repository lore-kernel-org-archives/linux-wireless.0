Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab2GLOYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 10:24:35 -0400
Message-ID: <1342103072.4531.26.camel@jlt3.sipsolutions.net> (sfid-20120712_162438_925878_E22D0741)
Subject: Re: [RFC] nl80211: Avoid checking for empty WoWLAN triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Jul 2012 16:24:32 +0200
In-Reply-To: <4FFD1014.2000109@qca.qualcomm.com>
References: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com>
	  <1341918365.4475.9.camel@jlt3.sipsolutions.net>
	  <4FFC0F22.6040906@qca.qualcomm.com>
	 <1341919201.4475.11.camel@jlt3.sipsolutions.net>
	 <4FFD1014.2000109@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-11 at 11:03 +0530, Mohammed Shafi Shajakhan wrote:

> > I don't know if there's any advantage. It could be useful for example to
> > get a connection up quicker after resume. I just didn't want to preclude
> > that use case.
> >
> 
> sorry i just missed this thing. rdev->wowlan is made 'false' for empty 

I think you mean "NULL"?

Maybe something like this would make sense then? 

http://p.sipsolutions.net/2aac79bcfe3a9b8b.txt

johannes

