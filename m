Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:55202 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965252AbbBBWxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 17:53:23 -0500
Received: by mail-qa0-f54.google.com with SMTP id w8so31466458qac.13
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 14:53:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ1dT9x+vWm4uZ-r9PZrTmKjEQc260NhOKoRzH=Ab=oWkeZ83w@mail.gmail.com>
References: <CAJ1dT9x+vWm4uZ-r9PZrTmKjEQc260NhOKoRzH=Ab=oWkeZ83w@mail.gmail.com>
From: Avery Pennarun <apenwarr@google.com>
Date: Mon, 2 Feb 2015 17:53:02 -0500
Message-ID: <CAPp0ZBZfdmwJNAtR6R1ue0OAj1pYh+L_kxRrixXD=3keLgKZKQ@mail.gmail.com> (sfid-20150202_235327_374467_9937821D)
Subject: Re: Open Source RRM & Hand-Over Optimization (WAS: Throughput
 regression with `tcp: refine TSO autosizing`)
To: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bs@anyfi.net>
Cc: David Reed <dpreed@reed.com>,
	dstanley <dstanley@arubanetworks.com>,
	Derrick Pallas <pallas@meraki.com>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2015 at 11:44 AM, Björn Smedman <bs@anyfi.net> wrote:
> On Mon, Feb 2, 2015 at 5:21 AM, Avery Pennarun <apenwarr@google.com> wrote:
>> While there is definitely some work to be done in handoff, it seems
>> like there are some find implementations of this already in existence.
>> Several brands of "enterprise access point" setups seem to do well at
>> this.  It would be nice if they interoperated, I guess.
>>
>> The fact that there's no open source version of this kind of handoff
>> feature bugs me, but we are working on it here and the work is all
>> planned to be open source, for example: (very early version)
>> https://gfiber.googlesource.com/vendor/google/platform/+/master/waveguide/
>
> We've got an SDN-inspired architecture with 802.11 frame tunneling (a
> la CAPWAP), airtime fairness, infrastructure initiated hand-over,
> Opportunistic Key Caching (OKC), IEEE 802.11r Fast BSS Transition and
> a few more goodies. It's currently free as in beer
> (http://anyfi.net/software,
> https://github.com/carrierwrt/carrierwrt/pull/7 and
> http://www.anyfinetworks.com/download) up to 100 APs, but we're
> definitely going to open source in one form or another.
>
> We've also tried to raise some interest in fixing up CAPWAP
> (https://www.ietf.org/mail-archive/web/opsawg/current/msg03196.html),
> which is (unfortunately) the best open standard at the moment.
> Interest seems marginal though...

This sounds cool.  Is the CAPWAP/encapsulation stuff separable from
the rest?  At 802.11ac speeds, a super fast WAN link, and a low-cost
SoC, too many layers can be a killer.
