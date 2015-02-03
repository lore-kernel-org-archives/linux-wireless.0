Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:61885 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbbBCKN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 05:13:56 -0500
Received: by mail-la0-f45.google.com with SMTP id gd6so49827630lab.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 02:13:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1502021506460.8636@nftneq.ynat.uz>
References: <CAJ1dT9x+vWm4uZ-r9PZrTmKjEQc260NhOKoRzH=Ab=oWkeZ83w@mail.gmail.com>
	<CAPp0ZBZfdmwJNAtR6R1ue0OAj1pYh+L_kxRrixXD=3keLgKZKQ@mail.gmail.com>
	<alpine.DEB.2.02.1502021506460.8636@nftneq.ynat.uz>
Date: Tue, 3 Feb 2015 11:13:54 +0100
Message-ID: <CAJ1dT9z+vjB--Ba4o7=YQ081wJwWDW_q26GTzNPchreCH_OH_Q@mail.gmail.com> (sfid-20150203_111359_974979_9E43E5A3)
Subject: Re: [Cerowrt-devel] Open Source RRM & Hand-Over Optimization (WAS:
 Throughput regression with `tcp: refine TSO autosizing`)
From: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bs@anyfi.net>
To: David Lang <david@lang.hm>
Cc: Avery Pennarun <apenwarr@google.com>,
	=?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bs@anyfi.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>,
	dstanley <dstanley@arubanetworks.com>,
	Derrick Pallas <pallas@meraki.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 3, 2015 at 12:27 AM, David Lang <david@lang.hm> wrote:
> On Mon, 2 Feb 2015, Avery Pennarun wrote:
>> On Mon, Feb 2, 2015 at 11:44 AM, Björn Smedman <bs@anyfi.net> wrote:
>>> We've got an SDN-inspired architecture with 802.11 frame tunneling (a
>>> la CAPWAP), airtime fairness, infrastructure initiated hand-over,
>>> Opportunistic Key Caching (OKC), IEEE 802.11r Fast BSS Transition and
>>> a few more goodies. It's currently free as in beer
>>> (http://anyfi.net/software,
>>> https://github.com/carrierwrt/carrierwrt/pull/7 and
>>> http://www.anyfinetworks.com/download) up to 100 APs, but we're
>>> definitely going to open source in one form or another.
>
> Please keep in touch, when it is released open source I'd be very interested
> in trying it for SCaLE. I'll probably exceed your 100 radio free limit this
> year, and it's hard to justify using non-free code at a linux conference
> (not impossible, but not something I'm going to try to do 3 weeks before the
> show :-)

Will do. :)

> I'm doing social engineering to push people to the 5GHz network (SSID for 5G
> is scale, for 2.4 is scale-slow), it would be great to be able to do this
> directly. And better handoffs as people move around would be good.
>
> It would also be good if something like this could help identify gaps in
> coverage. If it can identify cases where users go from having coverage to
> poor connectivity to having coverage, we can manually investigate to see
> where in the building that is and see what we can do to fix it.

Both of those should be well within scope. :)
