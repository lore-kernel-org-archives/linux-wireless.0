Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:39114 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2CTNAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 09:00:03 -0400
Message-ID: <4F687F4E.4030203@windriver.com> (sfid-20120320_140008_198469_63A4D6B2)
Date: Tue, 20 Mar 2012 20:59:58 +0800
From: Zhong Hongbo <hongbo.zhong@windriver.com>
MIME-Version: 1.0
To: Zhong Hongbo <hongbo.zhong@windriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
References: <4F687667.1030605@windriver.com> <1332247526.3329.17.camel@jlt3.sipsolutions.net> <4F687D82.2010201@windriver.com>
In-Reply-To: <4F687D82.2010201@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2012 08:52 PM, Zhong Hongbo wrote:
> On 03/20/2012 08:45 PM, Johannes Berg wrote:
>
>> On Tue, 2012-03-20 at 20:21 +0800, Zhong Hongbo wrote:
>>> I try the latest compat-wireless package to test Intel Centrino N-6205
>>> Taylor Peak Wi-Fi card  AP mode.
>>>
>>> 1. Test enviroment
>>> My Wi-Fi client:
>>> Dell Latitude E6400 desktop + Ubuntu 10.04,
>>> Dell Latitude E6400 desktop + Windows XP.
>>>
>>> Compat-wireless package: compat-wireless-2012-03-18.tar.bz2
>>>
>>> Wi-Fi AP: Intel Centrino N-6205 Taylor Peak
>>>
>>> 2. issue describe
>>> When I use E6400 + Ubuntu 10.04 connect to intel N-6205 Taylor PeaK
>>> AP， I can go to internet to browse web. E6400 + Windows XP can
>>> connect to intel N-6205 AP, But I can not go to internet.
>>> Is it interactions issue for the compat-wirelss package? Welcome any
>>> suggestion.
>> That's a bit confusing. Are you running DHCP etc. correctly?
> Thanks response. Yes, Because E6400 + ubuntu 10.04 can go to internet.
> I use E6400 + Ubuntu and E6400 + Windows to connect the Wi-Fi AP at the same time.
And E6400 + Windows get the correct ip and dns.

Thanks,
hongbo

>
> Thanks,
> hongbo
>
>> johannes
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

