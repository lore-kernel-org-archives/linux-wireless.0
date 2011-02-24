Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48986 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1BXSwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 13:52:30 -0500
Received: by yxs7 with SMTP id 7so405062yxs.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 10:52:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikPGHKMi_VVU23_2js96E7n=PVHjBzBujE1v3HX@mail.gmail.com>
References: <4D5DA039.9010907@gmail.com>
	<AANLkTikq2XA9c9FUQJ3cv7xjL69J=tHxLdwj8fiNnmhN@mail.gmail.com>
	<AANLkTikkv0QbzoHv_Z8cdDp7g67oG57tN7QaZv8NH4Na@mail.gmail.com>
	<AANLkTikPGHKMi_VVU23_2js96E7n=PVHjBzBujE1v3HX@mail.gmail.com>
Date: Thu, 24 Feb 2011 18:52:17 +0000
Message-ID: <AANLkTikJhhKQhmJv-8ac+htsESc_8GRLO4k_ZFRCK2GS@mail.gmail.com>
Subject: Re: Google Summer of Code 2011 - Project ideas page for the Linux
 Foundation online
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Till Kamppeter <till.kamppeter@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Greg KH <greg@kroah.com>,
	"lsb-discuss@lists.linux-foundation.org"
	<lsb-discuss@lists.linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Open Printing <printing-architecture@lists.linux-foundation.org>,
	Lars Uebernickel <larsuebernickel@gmx.de>,
	peter sikking <peter@mmiworks.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 24, 2011 at 8:11 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, Feb 23, 2011 at 4:52 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>> On Fri, Feb 18, 2011 at 2:18 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Thu, Feb 17, 2011 at 2:24 PM, Till Kamppeter
>>> <till.kamppeter@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I have set up a page for project ideas for the Linux Foundation's
>>>> participation in the Google Summer of Code 2011:
>>>>
>>>> https://www.linuxfoundation.org/collaborate/workgroups/gsoc/google-summer-code-2011
>>>>
>>>> Please add your ideas to the sub-page of your work group. If you have
>>>> problems mail me with your project idea.
>>>
>>> For 802.11 you can dump your ideas here:
>>>
>>> http://wireless.kernel.org/en/developers/GSoC/2011/
>>>
>>>  Luis
>>
>> Seeing as a few of the mac80211-based wireless drivers (for some of
>> the more dumb/basic/cheap devices) has gained access-point(AP)-mode
>> support code in the kernel recently in the last few months, it would
>> probably be appropriate to add (if it isn't already there) or enhance
>> access-point-mode support in some of the user-land tools like
>> NetworkManager, nm-applet, or wireless assistant?
>
> The dbus / supplicant stuff was done in GSoC 2009, see:
>
> http://wireless.kernel.org/en/developers/GSoC/2009/Add_AP_Support_to_Network_Manager
>
> Patches were sent to Jouni and IIRC the dbus stuff was the last stuff
> being figured out. So IIRC this was just a matter of userspace
> catchup. If we need that then sure, Dan?
>
>  Luis
>

Oh, so long ago :-). (GSoC 2009 would be  over a little over a year
ago). Somebody can write a user-friendly GUI wizard to do a
wireless-wired bridge i.e. plus netfilter nat/masquerading config?
Does hostapd has a dbus interface i.e. can it be invoked by the
console owner on-the-fly? It does not seem to - would that be
useful/do-able as a student project?
