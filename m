Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3173 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab2LCIhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 03:37:34 -0500
Message-ID: <50BC64C4.9040001@broadcom.com> (sfid-20121203_093737_036614_156AC96E)
Date: Mon, 3 Dec 2012 09:37:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Daniel Wagner" <wagi@monom.org>
cc: "Seth Forshee" <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded
 debug/trace support
References: <50AA845C.2050809@monom.org> <50AB3182.5040505@monom.org>
 <20121120142822.GA26602@thinkpad-t410> <50ABC168.8080904@monom.org>
 <20121120205418.GB26602@thinkpad-t410> <50AC05A5.3090706@monom.org>
 <50AC07F2.8000400@monom.org> <50ACA28F.9010800@broadcom.com>
 <50ACA55F.5050406@monom.org> <20121121143528.GC23606@thinkpad-t410>
 <20121126193655.GF4556@thinkpad-t410> <50B3DD38.5060808@monom.org>
 <50BC6181.8080307@monom.org>
In-Reply-To: <50BC6181.8080307@monom.org>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/2012 09:23 AM, Daniel Wagner wrote:
> Hi Seth,
> 
> On 26.11.2012 22:20, Daniel Wagner wrote:
>> On 26.11.2012 20:36, Seth Forshee wrote:
>>> On Wed, Nov 21, 2012 at 08:35:28AM -0600, Seth Forshee wrote:
>>>>> My 'test' setup is following: I downloaded a larger file and let a
>>>>> youtube
>>>>> video play. With tracing enabled the download and the playback did
>>>>> work nicely.
>>>>>
>>>>> Without tracing enabled playing back only a youtube video was
>>>>> 'triggering'
>>>>> the problem. It downloads a few seconds of content in a burst and
>>>>> then the playback
>>>>> starts. Under normal conditions, the app will continue downloading
>>>>> the video at a
>>>>> lower rate. But this normally doesn't happen right now. Often it
>>>>> will just stop
>>>>> working and often the connection is completely blocked, e.g. pinging
>>>>> a host
>>>>> wont work.
>>>>
>>>> I'll see if I can reproduce, but if it's specific to the AP then I may
>>>> not have any luck. Don't expect to hear much from me until next week
>>>> though; I'm on holiday starting today and will be visiting family.
>>>
>>> It seems I'm unable to reproduce the problem with any of the APs
>>> available to me, unfortunately.
>>
>> I tried it again with disabled the TX trace but I can't reproduce it
>> either. Well, I am sick of this AP and I might just get a better one
>> (which should be fairly simple).
> 
> FYI, I got my old Netgear 11g AP out and I get a very 'smooth' wifi
> experience.
> 
> If you like you can add Tested-by tag :)

You basically tested 11g operation is ok. Still interesting to know,
because it may indicate that problems start happening when doing 11n
rates and/or A-MPDU sessions.

Gr. AvS

