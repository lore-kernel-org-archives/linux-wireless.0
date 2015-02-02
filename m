Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:36838 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965142AbbBBX1o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 18:27:44 -0500
Date: Mon, 2 Feb 2015 15:27:02 -0800 (PST)
From: David Lang <david@lang.hm>
To: Avery Pennarun <apenwarr@google.com>
cc: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bs@anyfi.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>,
	dstanley <dstanley@arubanetworks.com>,
	Derrick Pallas <pallas@meraki.com>
Subject: Re: [Cerowrt-devel] Open Source RRM & Hand-Over Optimization (WAS:
 Throughput regression with `tcp: refine TSO autosizing`)
In-Reply-To: <CAPp0ZBZfdmwJNAtR6R1ue0OAj1pYh+L_kxRrixXD=3keLgKZKQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1502021506460.8636@nftneq.ynat.uz> (sfid-20150203_002753_385201_611AF3B4)
References: <CAJ1dT9x+vWm4uZ-r9PZrTmKjEQc260NhOKoRzH=Ab=oWkeZ83w@mail.gmail.com> <CAPp0ZBZfdmwJNAtR6R1ue0OAj1pYh+L_kxRrixXD=3keLgKZKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1537533407-1422919622=:8636"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1537533407-1422919622=:8636
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 2 Feb 2015, Avery Pennarun wrote:

> On Mon, Feb 2, 2015 at 11:44 AM, Björn Smedman <bs@anyfi.net> wrote:
>> On Mon, Feb 2, 2015 at 5:21 AM, Avery Pennarun <apenwarr@google.com> wrote:
>>> While there is definitely some work to be done in handoff, it seems
>>> like there are some find implementations of this already in existence.
>>> Several brands of "enterprise access point" setups seem to do well at
>>> this.  It would be nice if they interoperated, I guess.
>>>
>>> The fact that there's no open source version of this kind of handoff
>>> feature bugs me, but we are working on it here and the work is all
>>> planned to be open source, for example: (very early version)
>>> https://gfiber.googlesource.com/vendor/google/platform/+/master/waveguide/
>>
>> We've got an SDN-inspired architecture with 802.11 frame tunneling (a
>> la CAPWAP), airtime fairness, infrastructure initiated hand-over,
>> Opportunistic Key Caching (OKC), IEEE 802.11r Fast BSS Transition and
>> a few more goodies. It's currently free as in beer
>> (http://anyfi.net/software,
>> https://github.com/carrierwrt/carrierwrt/pull/7 and
>> http://www.anyfinetworks.com/download) up to 100 APs, but we're
>> definitely going to open source in one form or another.

Please keep in touch, when it is released open source I'd be very interested in 
trying it for SCaLE. I'll probably exceed your 100 radio free limit this year, 
and it's hard to justify using non-free code at a linux conference (not 
impossible, but not something I'm going to try to do 3 weeks before the show :-)

I'm doing social engineering to push people to the 5GHz network (SSID for 5G is 
scale, for 2.4 is scale-slow), it would be great to be able to do this directly. 
And better handoffs as people move around would be good.

It would also be good if something like this could help identify gaps in 
coverage. If it can identify cases where users go from having coverage to poor 
connectivity to having coverage, we can manually investigate to see where in the 
building that is and see what we can do to fix it.

David Lang

>> We've also tried to raise some interest in fixing up CAPWAP
>> (https://www.ietf.org/mail-archive/web/opsawg/current/msg03196.html),
>> which is (unfortunately) the best open standard at the moment.
>> Interest seems marginal though...
>
> This sounds cool.  Is the CAPWAP/encapsulation stuff separable from
> the rest?  At 802.11ac speeds, a super fast WAN link, and a low-cost
> SoC, too many layers can be a killer.
> _______________________________________________
> Cerowrt-devel mailing list
> Cerowrt-devel@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/cerowrt-devel
--680960-1537533407-1422919622=:8636--
