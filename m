Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:65052 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbYFTOYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 10:24:50 -0400
Received: by wa-out-1112.google.com with SMTP id j37so935460waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jun 2008 07:24:50 -0700 (PDT)
Message-ID: <1ba2fa240806200724v7c20a553vaec38e2483fc2141@mail.gmail.com> (sfid-20080620_162455_983425_9EFB4BB6)
Date: Fri, 20 Jun 2008 17:24:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Mike Kershaw" <dragorn@kismetwireless.net>
Subject: Re: More 4965 woes
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080620131544.GA31113@drd1813.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080617132401.GA8328@drd1813.lan>
	 <1213781294.2625.52.camel@debian.sh.intel.com>
	 <20080618154109.GB15170@drd1813.lan>
	 <20080619134138.GA27021@drd1813.lan>
	 <1ba2fa240806191253l2769dec3q2a49638eafe01e48@mail.gmail.com>
	 <20080620131544.GA31113@drd1813.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 20, 2008 at 4:15 PM, Mike Kershaw
<dragorn@kismetwireless.net> wrote:
> On Thu, Jun 19, 2008 at 10:53:22PM +0300, Tomas Winkler wrote:
>> > On channel 36 things appear to work (well, as much as they do otherwise,
>> > packet hanging still makes the device unusable).  I'm still confused as
>> > to why the card can report it works on that channel, scan that channel,
>> > see beacons, but then refuse to transmit.
>>
>> There is a bug in the firmware. the fix is on the way. Unfortunately I
>> cannot currently commit to
>> to any particular day it will be published yet.
>
> That's fair enough, good to hear.
>
>> What AP do you use I don't see such bad behviour on A band.
>
> Which do you mean - The failure of radar channels, or the severe
> latency/packet loss?
>
> The severe latency/packet loss happens any time I enable HT, if I'm
> connected to a HT AP or not, 2.4ghz or 5ghz, in a clean RF environment.

I need a brand name so we can reproduce the problem
Thanks
