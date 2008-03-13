Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44437 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYCMQV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 12:21:58 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: bulk vs. interactive bandwidth
Date: Thu, 13 Mar 2008 09:18:00 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003E4E060@orsmsx416.amr.corp.intel.com> (sfid-20080313_162204_008468_9D5C9B5A)
In-Reply-To: <20080312213515.3C1A62DC045@tippex.mynet.homeunix.org>
References: <20080312213515.3C1A62DC045@tippex.mynet.homeunix.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Anders Eriksson" <aeriksson@fastmail.fm>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On ,  Anders Eriksson wrote:

> Hi,
> 
> I have an issue which I can't really narrow down and it might
> be wlan related.
> It occurs both from a couple of PCs sharing a rt2500 to the internet,
> and a iwl3945 (no sharing) to the net.
> 
> The thing is that, normal sufing works ok. But, whenever there
> is a big
> download going on (say grabbing a kernel tarball), the
> interactive performace
> drops to pretty much nothing. Getting a prompt from ssh can
> take close to a
> minute. I'm thinking tha, tperhaps, there is someting buffer related
> which makes the wlan buffers "deeper than normal" and thus makes it
> hard for the interactive tcp's to crate room for themselves in the
> transmission queues or
> somehting.
> 
> I can't recall seeing this phenomenon over a wired connection (with
> roughly the same link bandwidths.)
> 
> Dows this sound at all familiar? If so, what's the cure? (I'd rather
> not go into traffic shaping...)
> 

Which version of the iwl3945 driver are you using? The iwl3945 recently
received some patches to fix its rate scaling ... see
http://marc.info/?l=linux-wireless&m=120485409525437&w=2. Can you test
the latest iwl3945 driver from wireless-testing?

Thanks

Reinette
