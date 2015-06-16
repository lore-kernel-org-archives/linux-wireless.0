Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32939 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752824AbbFPHdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:33:18 -0400
Message-ID: <1434439990.3795.12.camel@coelho.fi> (sfid-20150616_093325_627271_EEAD8FD5)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <aspriel@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 16 Jun 2015 10:33:10 +0300
In-Reply-To: <557BCD1C.5010408@gmail.com>
References: <1434117644-3033-1-git-send-email-luca@coelho.fi>
	 <557BCD1C.5010408@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH py80211 0/4] py80211: add support for scheduled scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Sat, 2015-06-13 at 08:26 +0200, Arend van Spriel wrote:
> On 12-06-15 16:00, Luca Coelho wrote:
> > Here's a small patchset that adds support for scheduled scans in
> > py80211.
> 
> Thanks! One general remark. It seems you are using soft-tabs where I
> stick to true tabs. Python is pretty anal about that so better stick to
> true tabs.

Uh, sorry about this.  I just used what emacs does by default in
python-mode and didn't give this much thought.  I'll make sure my future
patches conform to pythonist tab analities. :)


> > I'm not sure this is the right approach, I added separate classes for
> > each command, so feel free to ask me to change it completely if you
> > want and I may or may not do it. :P
> 
> Me neither, but it may be a bit too classy ;-) So I would prefer to have
> a scheduled scan class with start and stop operation.

Yeah, I thought so too... In any case, I saw that you applied the classy
version.  Shall I rework this and send new patches or shall we leave it
as it is?


> Good to see you are using '_' consistently for class private members and
> functions. I need to clean it up in other files. I recently added Pyro
> support allowing remote access to py80211 objects and it only exposes
> public members and functions.

Yeah, I like the idea of being strict about private versus public
visibility.

There was a small mistake in one of the changes you made.  I'm going to
send a fix for it in a second.

Thanks for your help!

--
Luca.

