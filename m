Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55922 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab1BXILk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 03:11:40 -0500
Received: by iwn34 with SMTP id 34so162876iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 00:11:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikkv0QbzoHv_Z8cdDp7g67oG57tN7QaZv8NH4Na@mail.gmail.com>
References: <4D5DA039.9010907@gmail.com> <AANLkTikq2XA9c9FUQJ3cv7xjL69J=tHxLdwj8fiNnmhN@mail.gmail.com>
 <AANLkTikkv0QbzoHv_Z8cdDp7g67oG57tN7QaZv8NH4Na@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Feb 2011 00:11:19 -0800
Message-ID: <AANLkTikPGHKMi_VVU23_2js96E7n=PVHjBzBujE1v3HX@mail.gmail.com>
Subject: Re: Google Summer of Code 2011 - Project ideas page for the Linux
 Foundation online
To: Hin-Tak Leung <hintak.leung@gmail.com>,
	Dan Williams <dcbw@redhat.com>
Cc: Till Kamppeter <till.kamppeter@gmail.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Greg KH <greg@kroah.com>,
	"lsb-discuss@lists.linux-foundation.org"
	<lsb-discuss@lists.linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Open Printing <printing-architecture@lists.linux-foundation.org>,
	Lars Uebernickel <larsuebernickel@gmx.de>,
	peter sikking <peter@mmiworks.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 23, 2011 at 4:52 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Fri, Feb 18, 2011 at 2:18 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Feb 17, 2011 at 2:24 PM, Till Kamppeter
>> <till.kamppeter@gmail.com> wrote:
>>> Hi,
>>>
>>> I have set up a page for project ideas for the Linux Foundation's
>>> participation in the Google Summer of Code 2011:
>>>
>>> https://www.linuxfoundation.org/collaborate/workgroups/gsoc/google-summer-code-2011
>>>
>>> Please add your ideas to the sub-page of your work group. If you have
>>> problems mail me with your project idea.
>>
>> For 802.11 you can dump your ideas here:
>>
>> http://wireless.kernel.org/en/developers/GSoC/2011/
>>
>>  Luis
>
> Seeing as a few of the mac80211-based wireless drivers (for some of
> the more dumb/basic/cheap devices) has gained access-point(AP)-mode
> support code in the kernel recently in the last few months, it would
> probably be appropriate to add (if it isn't already there) or enhance
> access-point-mode support in some of the user-land tools like
> NetworkManager, nm-applet, or wireless assistant?

The dbus / supplicant stuff was done in GSoC 2009, see:

http://wireless.kernel.org/en/developers/GSoC/2009/Add_AP_Support_to_Network_Manager

Patches were sent to Jouni and IIRC the dbus stuff was the last stuff
being figured out. So IIRC this was just a matter of userspace
catchup. If we need that then sure, Dan?

  Luis
