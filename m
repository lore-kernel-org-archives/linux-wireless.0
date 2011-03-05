Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58362 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1CEJpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 04:45:24 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	<20110304134648.GB9866@tuxdriver.com>
	<1299251879.24333.3.camel@wwguy-ubuntu>
	<AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	<AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
Date: Sat, 5 Mar 2011 09:45:22 +0000
Message-ID: <AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
Subject: Re: 2.6.38-rc7, iwlagn crash
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 March 2011 03:45, Mathias Burén <mathias.buren@gmail.com> wrote:
> On 4 March 2011 22:23, Mathias Burén <mathias.buren@gmail.com> wrote:
>> On 4 March 2011 15:17, wwguy <wey-yi.w.guy@intel.com> wrote:
>>> On Fri, 2011-03-04 at 05:46 -0800, John W. Linville wrote:
>>>> Cc'ing Wey-yi and linux-wireless...anyone else having problems with
>>>> iwlagn and IBSS?
>>>>
>>>> On Fri, Mar 04, 2011 at 03:27:22AM +0000, Mathias Burén wrote:
>>>> > Hi,
>>>> >
>>>> > (please cc as not subscribed)
>>>> >
>>>> >
>>>> >
>>>> > I think the crash happens when the phone attempts to get an IP, at
>>>> > least that's what the phone says right after/at the crash. Any ideas?
>>>> >
>>>> >
>>> forwarding to my team to work on it, any additional information you can
>>> provide?
>>>
>>> It is in IBSS mode, do you have any information can shared with us on
>>> your phone's model, setup, and ...
>>> if you can load the module with debug=0x43fff and provide the dmesg log,
>>> it will be very helpful
>>>
>>> Thanks
>>> Wey
>>>
>>>
(snip)

I compiled my own kernel (downloaded 2.6.37-rc8 source, applied the
apparmor patch required for Ubuntu, copied over the config, make
oldconfig, enabled iwlwifi debug in menuconfig then compiled it),
booted it and loaded iwlagn with debug=0x43fff. Then I attempted the
same thing (Ubuntu Adhoc, no wireless security, trying to connect with
the phone).

The entire dmesg can be found here:
http://www.privatepaste.com/download/49e6ead6c7

Regards,
// Mathias
