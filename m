Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42357 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab1AVChv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 21:37:51 -0500
Received: by qyk12 with SMTP id 12so2607127qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 18:37:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimf-GodWmUqbJkCiP_BPChAT60oQ0ZVTRq_0p73@mail.gmail.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
 <1295654809-5790-5-git-send-email-wey-yi.w.guy@intel.com> <AANLkTinqZ-7E943Qd8swN0hS5XFaSeayBm75Lkz768Bv@mail.gmail.com>
 <AANLkTik11iCqMF+pRYX7jvzj03t_cTCZh1ivb1Tt3L01@mail.gmail.com> <AANLkTimf-GodWmUqbJkCiP_BPChAT60oQ0ZVTRq_0p73@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 22 Jan 2011 03:37:30 +0100
Message-ID: <AANLkTimqmEYWpV89+cUebvV0Ai-2vobmVY5tiO5R8cOa@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 04/14] iwlagn: 2000 series devices support
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/22 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2011/1/22 Daniel Halperin <dhalperi@cs.washington.edu>:
>> 2011/1/21 Gábor Stefanik <netrolller.3d@gmail.com>:
>>> On Sat, Jan 22, 2011 at 1:06 AM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
>>>> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>>>>
>>>> Adding 2000 series devices supports, the 2000 series devices has
>>>> many different SKUs which includes 1x1 and 2x2 devices,also with
>>>
>>> Is it just me, or is Intel really abandoning 3-stream 802.11n technology?
>>
>> It's just you.  They released the 6300 not that long ago!  But think
>> about the market, how many 3-stream APs can you buy today?
>
> Well, there is the Airport Extreme, the D-Link DIR-665 (with a
> Marvell-chipped mini-PCI card inside), and also an offering from

my bad... mini-PCIE.

> Senao.
>
>> Atheros
>> still doesn't even have a 3-stream NIC end users can buy (though some
>> companies are getting close!), but Intel's had one for nearly 3 years.
>>
>> There's a lot more room in the market at the low end, and that's where
>> it makes sense to put your efforts towards product diversity.
>> Manufacturers are looking for chips for printers, phones, netbooks,
>> tiny laptops, etc., why would they pay for the silicon for extra
>> processing and the design constraints(!) for extra antennas when it's
>> not going to get used?  Heck, a lot of these APs (see, e.g., Apple's
>> airport express) only come with 100 Mbps wired ports!
>>
>> Dan
>>
>
> The problem is that what I currently see is that Intel is updating the
> basic 2x2 half-mini offering (true, they are also releasing Bluetooth
> combos and other new devices, but AFAIK one of the "g2" devices is
> exactly the same feature-wise as the Centrino 6200), while the 6300
> has not received any update ("released not that long ago"? AFAIK it's
> been a year at least since it came out), and the 6350 was cancelled
> before release, leaving 5350 without a successor.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
