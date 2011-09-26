Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14875 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1IZVe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:34:59 -0400
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM
 Fritz!Box (7390)" incompatible
From: wwguy <wey-yi.w.guy@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJTrwG5ydoheYzYuRZaaR0AfqBgE9KnfYQ8X_0esRNVog3hF=g@mail.gmail.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	 <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	 <1317048872.2400.4.camel@wwguy-ubuntu>
	 <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
	 <1317049160.1958.8.camel@wwguy-huron>
	 <CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
	 <CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com>
	 <1317050380.1958.13.camel@wwguy-huron>
	 <CAJTrwG46qRYvda1vcCZXv0BTUyf26gx2qgpNgOG-bm-BCMpqfg@mail.gmail.com>
	 <1317053131.1958.15.camel@wwguy-huron>
	 <C5A7FB31FD9AEA42B600BDC3C74F8E0017052223@orsmsx511.amr.corp.intel.com>
	 <CAJTrwG5AvbtNRZi54tzAoUDv5X9QLVY3L=-OgHYRtnJ-RMesrQ@mail.gmail.com>
	 <1317062004.1958.18.camel@wwguy-huron>
	 <CAJTrwG57r-B-eT-FODsDW1UgoVcS68zcUWo1mOrdHRdoXtNmCg@mail.gmail.com>
	 <C5A7FB31FD9AEA42B600BDC3C74F8E001705253B@orsmsx511.amr.corp.intel.com>
	 <CAJTrwG5MXfixhnNPOdoA3-DYEeKpC==uv4WvE78ZE5U+A10T7Q@mail.gmail.com>
	 <1317071501.2400.10.camel@wwguy-ubuntu>
	 <CAJTrwG6_ybjD9u2zMi+bY73j6CZoncbmOzk8N2N=8Cd=EWLUcA@mail.gmail.com>
	 <1317071853.2400.11.camel@wwguy-ubuntu>
	 <CAJTrwG5ydoheYzYuRZaaR0AfqBgE9KnfYQ8X_0esRNVog3hF=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 14:29:32 -0700
Message-ID: <1317072572.2400.12.camel@wwguy-ubuntu> (sfid-20110926_233504_152716_5C49726B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 14:31 -0700, Henrik Friedrichsen wrote:
> On Mon, Sep 26, 2011 at 11:17 PM, wwguy <wey-yi.w.guy@intel.com> wrote:
> > how about just doing a flood ping to your AP
> > #sudo ping -f <AP's ip address>
> 
> Okay, here's what's happening:
> ~ > ping -f fritz.box
> PING fritz.box (192.168.178.1) 56(84) bytes of data.
> ping: cannot flood; minimal interval, allowed for user, is 200ms
> 
> When I send regular pings:
> ~ > ping -c5 fritz.box
> PING fritz.box (192.168.178.1) 56(84) bytes of data.
> 64 bytes from fritz.box (192.168.178.1): icmp_req=1 ttl=64 time=1.31 ms
> 64 bytes from fritz.box (192.168.178.1): icmp_req=2 ttl=64 time=1.26 ms
> 64 bytes from fritz.box (192.168.178.1): icmp_req=3 ttl=64 time=1.30 ms
> 64 bytes from fritz.box (192.168.178.1): icmp_req=4 ttl=64 time=2.51 ms
> 64 bytes from fritz.box (192.168.178.1): icmp_req=5 ttl=64 time=1.22 ms
> 
> --- fritz.box ping statistics ---
> 5 packets transmitted, 5 received, 0% packet loss, time 32046ms
> rtt min/avg/max/mdev = 1.226/1.524/2.515/0.496 ms
> 
> As you can see, the packets get there and the response goes back to
> me. But it seems to take ages for the package to be sent. I've sent
> five pings and got my response back in regular latency, however the
> whole process took 32 seconds.

$sudo ping -f fritz.box

Wey


