Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab1AVCMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 21:12:33 -0500
Received: by iwn9 with SMTP id 9so2294888iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 18:12:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinqZ-7E943Qd8swN0hS5XFaSeayBm75Lkz768Bv@mail.gmail.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
 <1295654809-5790-5-git-send-email-wey-yi.w.guy@intel.com> <AANLkTinqZ-7E943Qd8swN0hS5XFaSeayBm75Lkz768Bv@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, 21 Jan 2011 18:12:12 -0800
Message-ID: <AANLkTik11iCqMF+pRYX7jvzj03t_cTCZh1ivb1Tt3L01@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 04/14] iwlagn: 2000 series devices support
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/21 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sat, Jan 22, 2011 at 1:06 AM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
>> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>>
>> Adding 2000 series devices supports, the 2000 series devices has
>> many different SKUs which includes 1x1 and 2x2 devices,also with
>
> Is it just me, or is Intel really abandoning 3-stream 802.11n technology?

It's just you.  They released the 6300 not that long ago!  But think
about the market, how many 3-stream APs can you buy today?  Atheros
still doesn't even have a 3-stream NIC end users can buy (though some
companies are getting close!), but Intel's had one for nearly 3 years.

There's a lot more room in the market at the low end, and that's where
it makes sense to put your efforts towards product diversity.
Manufacturers are looking for chips for printers, phones, netbooks,
tiny laptops, etc., why would they pay for the silicon for extra
processing and the design constraints(!) for extra antennas when it's
not going to get used?  Heck, a lot of these APs (see, e.g., Apple's
airport express) only come with 100 Mbps wired ports!

Dan
