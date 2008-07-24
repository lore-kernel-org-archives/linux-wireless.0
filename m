Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55108 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYGXFk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 01:40:59 -0400
Message-ID: <488815DE.2000903@lwfinger.net> (sfid-20080724_074138_650902_04B49030)
Date: Thu, 24 Jul 2008 00:40:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
 rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>	 <200807221613.34434.herton@mandriva.com.br>	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>	 <200807221940.20009.herton@mandriva.com.br>	 <4886AA3B.3000406@lwfinger.net> <4886C50E.6040304@lwfinger.net>	 <1216824917.13587.9.camel@johannes.berg>	 <48874F09.7060400@lwfinger.net> <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com>
In-Reply-To: <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> Your patch actually works here! :-). Maybe you should retest?
> 
> It doesn't patch cleanly against wireless-testing - just indentation
> oddness, I think.
> Had to apply the patch by hand. but I am using it right now, so it
> seems to work.

As I wasn't planning on it to be an official patch, I did not handle it with the
usual care. My mailer is Thunderbird, and it does mess with the white space in
patches.

> If somebody else retest okay, can we have this in wireless-testing
> prompto, please?

To retest, I did a 'git checkout 741b4fbc44' and then applied my patch just in
case there was a second breakage of the driver in the tree. It worked for a
while, then went offline, but then so did the case with 741b4fbc44 reverted. I 
think some of my problems may have been due to overheating. I thought we had 
that problem licked, but maybe not.

I will be submitting the proper patch tomorrow, particularly if it works for others.

Larry


