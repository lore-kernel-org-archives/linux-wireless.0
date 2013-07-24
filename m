Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:49339 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3GXQBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 12:01:51 -0400
Message-ID: <51EFF8FC.8070101@opentechinstitute.org> (sfid-20130724_180156_173832_9223AD86)
Date: Wed, 24 Jul 2013 11:55:40 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <libnl-owner@lists.infradead.org>
Subject: Re: interested in py80211?
References: <51D49027.9010803@broadcom.com> ( sfid-20130703_225725_898124_EAB997AB) <1373616129.8205.2.camel@jlt4.sipsolutions.net> <51E00577.60305@broadcom.com>
In-Reply-To: <51E00577.60305@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for posting about this effort. I would be very interested in
helping out on development. I will stay up-to-date on things via your
github page. Otherwise, please continue to keep the list updated on your
progress.

Will

On 07/12/2013 09:32 AM, Arend van Spriel wrote:
> On 07/12/13 10:02, Johannes Berg wrote:
>> Yep, I'd totally be interested. Not that I don't have enough things on
>> my plate already ;-)
>>
>> On Wed, 2013-07-03 at 22:57 +0200, Arend van Spriel wrote:
>>> A common say in Linux arena is "when you have an itch, just scratch it".
>>
>> :-)
>>
>>> My itch is that tools like ifconfig and iw are great, but in an
>>> automated test environment it kind of sucks to parse output, which is
>>> confirmed by blurb from iw: "Do NOT screenscrape this tool, we don't
>>> consider its output stable.".
>>
>> Heh, yeah ...
>>
>>> Ever since my first contact with Python I tend to favor it over other
>>> scripting alternatives so I decided to scratch my itch with that and
>>> another old acquaintance called SWIG. With those I went to create
>>> py80211. A first attempt was to have SWIG create a wrapper API directly
>>> exposing the libnl-3 API, but that did not feel comfortable in a
>>> scripting environment. So the level of abstraction is a bit higher. It
>>> is just in a kick-off state (eg. can only send u32 attributes), but I
>>> decided to push it to github anyway.
>>
>> Another approach might be exposing the libnl APIs and then build a
>> higher-level library in python. Have you considered that? That might
>> make it useful to other users of netlink as well, while keeping a 'nice'
>> nl80211 API?
> 
> I am still at that fork in the road and not sure about it. The libnl
> project itself already has libnl stuff exposed in a python lib being the
> core api and route. So I could go and add genl support to that and build
> the high-level python library from there.
> 
> Regards,
> Arend
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
