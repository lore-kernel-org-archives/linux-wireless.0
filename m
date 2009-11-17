Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:59231 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZKQXZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 18:25:30 -0500
Message-ID: <4B033072.9030604@erley.org>
Date: Tue, 17 Nov 2009 18:23:30 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>	 <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>	 <1803.194.45.26.221.1258473872.squirrel@webmail.madwifi-project.org>	 <43e72e890911170838g26172725ga4a843dc5292c29f@mail.gmail.com> <b6c5339f0911171351m6c7e4e13o8f4329a6f8fb6f8d@mail.gmail.com>
In-Reply-To: <b6c5339f0911171351m6c7e4e13o8f4329a6f8fb6f8d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Tue, Nov 17, 2009 at 11:38 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> 
>>  * DFS
>>  * Multi-BSS AP functionality
>>  * Roaming
>>  * ANI
> 
> Also antenna selection has been requested -- this is dead simple
> if anyone wants to write appropriate hooks into the stack for it.
> The code is already in the driver, it just needs some configuration
> glue.
> 
I'm more than willing to attack adding the funtionality to ath5k, if someone else 
is willing to design and implement the mac80211/nl80211 layer stuff.  I tried 
doing the half/quarter rate stuff, but got hung up in the higher level, eventually 
giving up (with, I believe, working ath5k code for it).  I'd code and test with 
/debug options to get ath5k supporting the features, and then using the mac80211 
hooks once they're provided.

Pat Erley
