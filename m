Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-147-71.gdrpmi.dsl-w.verizon.net ([71.115.147.71]:42205
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYLMAKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 19:10:08 -0500
Message-ID: <4942FD59.8020401@erley.org> (sfid-20081213_011012_201934_47206B25)
Date: Fri, 12 Dec 2008 19:10:01 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Userspace tools: Roadmap?
References: <1228692546.8826.1288759933@webmail.messagingengine.com>	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>	 <1228778295.10662.1288975589@webmail.messagingengine.com>	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>	 <1228780960.22164.162.camel@johannes.berg>  <4941EF69.5040108@erley.org>	 <1229099080.14423.15.camel@dv> <1229119118.3572.6.camel@johannes.berg>	 <4942E7A4.3050206@erley.org> <1229121535.3565.4.camel@johannes.berg>	 <4942F867.5020203@erley.org> <1229126725.3565.30.camel@johannes.berg>
In-Reply-To: <1229126725.3565.30.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2008-12-12 at 18:48 -0500, pat-lkml wrote:
>> This converts iw to use libnl-2, and adds compatibility with libnl-1.
>> There is not currently a good way to detect the libnl version during
>> compilation, as the versioning in the netlink/version.h is defined as
>> a
>> string "2.0" rather than a major and a minor number, so we must detect
>> it in the Makefile.
>>
>> Signed-off-by: Pat Erley <pat-lkml@erley.org>
> 
> Ok, I've committed a slightly different version of this (corrected the
> type, and made the compat code static inlines), can you verify it still
> works against 2.0?
> 
> johannes
Yep, works fine with 2.0
