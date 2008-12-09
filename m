Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-133-90.gdrpmi.dsl-w.verizon.net ([71.115.133.90]:55223
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYLIAII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 19:08:08 -0500
Message-ID: <493DB6E0.20004@erley.org> (sfid-20081209_010813_519046_D13039FC)
Date: Mon, 08 Dec 2008 19:08:00 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Userspace tools: Roadmap?
References: <1228692546.8826.1288759933@webmail.messagingengine.com>	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>	 <1228778295.10662.1288975589@webmail.messagingengine.com>	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org> <1228780960.22164.162.camel@johannes.berg>
In-Reply-To: <1228780960.22164.162.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2008-12-08 at 18:52 -0500, pat-lkml wrote:
>> Johannes Berg wrote:
>>> On Mon, 2008-12-08 at 18:18 -0500, Dan E wrote:
>>> There's libnl 1.2 and 2.0? That's news to me! Patches welcome. Sorry, I
>>> guess it needs 1.0 or 1.1, will fix the page.
>>>
>> following is a patch that gets iw working with the development versions
>> of libnl.  I keep it uptodate at: http://wireless.erley.org/
>>
>> The Makefile changes may not be the 'best' way to do it, but it works
>> for me.
> 
> Thanks, I think you even sent me that once before already, but that
> breaks with distro versions of libnl. I guess distros will end up
> shipping 1.1 as libnl1 like debian does for a while?
> 
> Is there any particular reason you need libnl from git? You could just
> check out 1.1, no?
The reason I'm using git for everything in there is just because I have
it working.  Once master mode is in a released mainline, and stable
packages are released for all of the packages involved, I'll take the
time to revise a new copy of the document that links to 'good' versions,
and get it hosted on something more capable/dependable than my home dsl
line.  Also, someone else may have pushed a similar patch to you, as I
have not sent one upstream.

As far as distros bundling libnl, I know gentoo is shipping 1.1, and am
guessing it will be the version standardized on.

Pat

