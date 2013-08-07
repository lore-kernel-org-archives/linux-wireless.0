Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1642 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab3HGKjk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 06:39:40 -0400
Message-ID: <520223DB.5050701@broadcom.com> (sfid-20130807_123943_137484_97DB6E96)
Date: Wed, 7 Aug 2013 12:39:23 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kalle Valo" <kvalo@adurom.com>
cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ben Greear" <greearb@candelatech.com>,
	"Paul Stewart" <pstew@chromium.org>,
	"Felix Fietkau" <nbd@openwrt.org>, "Jouni Malinen" <j@w1.fi>
Subject: Re: 802.11 infrastructure for regression testing - upstream /
 mac80211 / cfg80211
References: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
 <51F8DA75.8040903@broadcom.com> <87li4gwosw.fsf@purkki.adurom.net>
In-Reply-To: <87li4gwosw.fsf@purkki.adurom.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/05/2013 09:59 AM, Kalle Valo wrote:
> "Arend van Spriel" <arend@broadcom.com> writes:
>
>> I am considering coming up with a new test framework for the brcm80211
>> drivers using python scripting, which is why I started py80211
>> experiment (available on github), but your mentioning of autotest
>> makes me want to revisit that.
>
> No no, please forget anything your heard about autotest and just focus
> on py80211 ;)
>
> More seriously, my experience with the autotest and any other test
> frameworks are that they are so freaking huge and difficult to maintain
> that eventually they just die. Small is beautiful and I have been
> dreaming about a lean and mean python based nl80211 test harness for
> drivers, but never found the time to do anything (my usual story). So
> I'm eagerly waiting how your py80211 will workout.

I am on vacation now so I may end up working on it. Although, I do have 
an almost 5yr old son claiming most of my time :-)

Anyway, there have been a few patches applied to libnl itself to support 
genl in python. So I can send and receive netlink messages and 
notifications as a python dictionary of netlink attributes. Now need to 
determine the level of abstraction I want to provide to users of 
py80211. Suggestions are more than welcome.

Regards,
Arend


