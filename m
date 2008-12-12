Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-147-71.gdrpmi.dsl-w.verizon.net ([71.115.147.71]:35669
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYLLWoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:44:25 -0500
Message-ID: <4942E7A4.3050206@erley.org> (sfid-20081212_234427_706698_0F4F4E96)
Date: Fri, 12 Dec 2008 17:37:24 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Userspace tools: Roadmap?
References: <1228692546.8826.1288759933@webmail.messagingengine.com>	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>	 <1228778295.10662.1288975589@webmail.messagingengine.com>	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>	 <1228780960.22164.162.camel@johannes.berg>  <4941EF69.5040108@erley.org>	 <1229099080.14423.15.camel@dv> <1229119118.3572.6.camel@johannes.berg>
In-Reply-To: <1229119118.3572.6.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Thanks for the review, Pavel.
> 
> I agree with all you've said, Pat, care to make a new patch?
> 
> johannes

Pavel reviewed a newer version for me while I was at work today.  I
didn't post it to the list as I didn't have access to this account.  I'm
going to implement the new set of changes and try to submit a new patch
some time tonight.  One question, is it preferred to make the code use
the new API and add compatibility to make it use the old API, or vice
versa?  I've written a function that uses the new
genl_ctrl_alloc_cache(arg1, &arg2) syntax wrapped in the old arg2 =
genl_ctrl_alloc_cache(arg1) syntax already, but based on Pavel's
suggestions, it seems it's preferred to go the other way?

Pat
