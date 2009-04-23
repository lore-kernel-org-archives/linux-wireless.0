Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:51957 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZDWLj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 07:39:58 -0400
Received: by ewy24 with SMTP id 24so450921ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 04:39:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240483530.30082.178.camel@johannes.local>
References: <5b8543210904220608l484d0d2dv73b0d66cdc167ce@mail.gmail.com>
	 <1240442334.14995.12.camel@localhost.localdomain>
	 <5b8543210904230336j177998c4m1e0af03fbb3584df@mail.gmail.com>
	 <1240483530.30082.178.camel@johannes.local>
Date: Thu, 23 Apr 2009 13:39:57 +0200
Message-ID: <5b8543210904230439r45c982fbn66c1a2080adcd442@mail.gmail.com> (sfid-20090423_134006_030494_9646AD38)
Subject: Re: Measure RSSI in adhoc networks
From: Kai Timmer <email@kait.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/23 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2009-04-23 at 12:36 +0200, Kai Timmer wrote:
>
>> I need the RSSI values for distance measurements between the nodes.
>
> Note that is very unreliable...

I know, it is a work for my diploma thesis. I'm trying to combine it
with some kind of round trip time measurements. It is in the very
early stages,...

>> So
>> what i need is not a "quality value" for the whole network, but the
>> recieved mW from every reachable point in the network. So i think the
>> RSSI value for every network node (if i can print them out seperatly)
>> should do the job.
>
> iw dev wlan0 station dump

That works on my laptop, but on not on my Openmoko Freerunner devices.
There I get the following:

runner1:~# iw dev eth1 station dump
nl80211 not found.

I assume that something with the freerunner wireless driver is not
compatible with the linux wireless stack. The driver is called
"ar6000".

Greets,
-- 
Kai Timmer
Email : email@kait.de
Jabber: kai@kait.de
Blog: http://blog.kaitimmer.de
