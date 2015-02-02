Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:46491 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679AbbBBHIU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 02:08:20 -0500
Date: Sun, 1 Feb 2015 23:07:23 -0800 (PST)
From: David Lang <david@lang.hm>
To: Avery Pennarun <apenwarr@google.com>
cc: David Reed <dpreed@reed.com>, dstanley@arubanetworks.com,
	Andrew McGregor <andrewmcgr@gmail.com>,
	Stig Thormodsrud <stig@ubnt.com>, netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jesper Dangaard Brouer <jbrouer@redhat.com>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>,
	Matt Mathis <mattmathis@google.com>,
	Derrick Pallas <pallas@meraki.com>,
	Kathy Giori <kgiori@qca.qualcomm.com>,
	Mahesh Paolini-Subramanya <mahesh@dieswaytoofast.com>,
	Jonathan Morton <chromatix99@gmail.com>,
	Tim Shepard <shep@alum.mit.edu>
Subject: Re: [Cerowrt-devel] Fwd: Throughput regression with `tcp: refine
 TSO autosizing`
In-Reply-To: <CAPp0ZBa43kVBWN5iGgmW=-YQAkdm2DrmMN0URvVu=yXA-_TZCQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1502012249100.19609@nftneq.ynat.uz> (sfid-20150202_080826_390015_002728EC)
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com> <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com> <54CB5D08.2070906@broadcom.com> <1422623975.21689.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <54CB8B69.1070807@broadcom.com> <CAA93jw5fqhz0Hiw74L2GXgtZ9JsMg+NtYydKxKzGDrvQcZn4hA@mail.gmail.com> <CAA93jw7b0E9jjQYXrEPzjLLC9j8xNC0TFYXpWVtgFameJaNBdw@mail.gmail.com> <1422741065.199624134@apps.rackspace.com> <CAPp0ZBb2nkA6Y0s=W0kw=zvyn0wi0NMBRsBCw_xcD61ScOmgQg@mail.gmail.com>
 <CAA_e5Z46Bu+zZZFzf_ejzA35Gw3g1_OG85yv6yd7MpbwZcE-nw@mail.gmail.com> <CAA93jw7=oTex0Mp-0ThvuDRUnfR0N8tzdOQ8DD7QYWphp1b=4w@mail.gmail.com> <CAJq5cE3ETbpEtecFHmhgHQveNRUhVfrzjTOygHm-TRCTwHNyKA@mail.gmail.com> <1422801814.796219699@apps.rackspace.com>
 <CAPp0ZBa43kVBWN5iGgmW=-YQAkdm2DrmMN0URvVu=yXA-_TZCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 1 Feb 2015, Avery Pennarun wrote:

> On Sun, Feb 1, 2015 at 9:43 AM,  <dpreed@reed.com> wrote:
>> I personally think that things like promoting semi-closed, essentially
>> proprietary ESSID-based bridged distribution systems as "good ideas" are
>> counterproductive to this goal.  But that's perhaps too radical for this
>> crowd.
>
> Not sure what you mean here.  ESSID-based distribution systems seem
> pretty well defined to me.  The only proprietary part is the
> decision-making process for assisted roaming (ie. the "inter-AP
> protocol") which is only an optional performance optimization.  There
> really should be an open source version of this, and I'm in fact
> feebly attempting to build one, but I don't feel like the world is
> falling apart through not having it.  You can build a bridged
> multi-BSS ESSID today with plain out-of-the-box hostapd.

I will be running a fully opensource bridged ESSID system at SCaLE this month. 
last year we had ~2500 people and devices with ~50 APs deployed, and it worked 
well. The only problem was that I needed to deploy a few more APs to cover some 
of the hallway areas more reliably.

There are tricks that the commercial systems pull that I can't currently 
duplicate with opensource tools. But as Avery says, they are optimizations, not 
something required for successful operation. It would be nice to get the 
assisted roaming portion available. But it's not required.

David Lang
