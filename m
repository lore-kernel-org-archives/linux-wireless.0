Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58005 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0LUJae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 04:30:34 -0500
Received: by qyj19 with SMTP id 19so5018070qyj.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 01:30:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292923526.2577.53.camel@macbook.infradead.org>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	<AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
	<4CFFA112.7030800@lwfinger.net>
	<885729A3-72D4-4EFC-AAFE-D2B573E00ED9@ing.unibs.it>
	<1292006874.3531.4.camel@jlt3.sipsolutions.net>
	<4D02793E.2050004@lwfinger.net>
	<AANLkTik2MdDg4g4dFuB6ozZ3Pp3pPORmSAxRAbtznTLP@mail.gmail.com>
	<1292008120.3531.5.camel@jlt3.sipsolutions.net>
	<1292923526.2577.53.camel@macbook.infradead.org>
Date: Tue, 21 Dec 2010 10:30:33 +0100
Message-ID: <AANLkTikrC2v74XhAXV2nOQ=6oW2_405yasq_2aDj25fe@mail.gmail.com>
Subject: Re: b43 N PHY status report
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/21 David Woodhouse <dwmw2@infradead.org>:
> On Fri, 2010-12-10 at 20:08 +0100, Johannes Berg wrote:
>> On Fri, 2010-12-10 at 20:04 +0100, Gábor Stefanik wrote:
>> > On Fri, Dec 10, 2010 at 8:02 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> > > On 12/10/2010 12:47 PM, Johannes Berg wrote:
>> > >> On Fri, 2010-12-10 at 19:30 +0100, Francesco Gringoli wrote:
>> > >>
>> > >>> [ 1117.516031] unregister_netdevice: waiting for wlan1 to become free. Usage count = 1
>> > >>>
>> > >>> and the device is never release (by who?). I have to reboot.
>> > >>
>> > >> That's a bug in the ipv6 code, upgrade your kernel :-)
>> > >
>> > > I would not have seen that as IPv6 is disabled in my kernels.
>> >
>> > Are you serious? Disabling ipv6 with ipv4 exhaustion expected in January?
>>
>> Can we stop this thread right here and go on-topic again please?
>
> On-topic:
>
> Anyone working on or testing network device drivers should be using
> IPv6. IPv6 will exercise code paths and network behaviour that Legacy IP
> rarely does, in particular using multicast to do neighbour discovery.
> And on wireless networks when multicast will be handled differently by
> the AP, that makes more difference than on wired where it's mostly the
> MAC filters that get neglected.
>
> I've seen a number of broken drivers because their authors were only
> testing with Legacy IP and not IPv6.
>
> It's not hard to set up IPv6. Larry, if you need any pointers I'd be
> more than happy to help.

I've router with OpenWRT, so that probably should be possible for me
to setup IPv6. However first I want to have working basic PHY and
radio configuration.

-- 
Rafał
