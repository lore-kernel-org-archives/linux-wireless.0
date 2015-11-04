Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33036 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbbKDHeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 02:34:04 -0500
Message-ID: <1446622439.2478.5.camel@sipsolutions.net> (sfid-20151104_083433_915598_E7A26DAE)
Subject: Re: Intel 7260 - limited in 5GHz spectrum
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Harvey <tharvey@gateworks.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Pushpal Sidhu <psidhu@gateworks.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 04 Nov 2015 08:33:59 +0100
In-Reply-To: <CAJ+vNU1d8=Z=0j_1jaqh__830-K56MnnM=5w550+e15NveqeOg@mail.gmail.com> (sfid-20151103_184304_584889_0EBF3178)
References: <CAD1M061nR5s6MFLHtoYDk05Ewz_3SHevB6s7qTB59qz681NLUg@mail.gmail.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8B86B4@hasmsx107.ger.corp.intel.com>
	 <CAJ+vNU3u_KCOjRi1HR_f9hCi-aYYMDciR7C0+nCwJh3N6GAETQ@mail.gmail.com>
	 <1446568044.29010.25.camel@sipsolutions.net>
	 <CAJ+vNU1d8=Z=0j_1jaqh__830-K56MnnM=5w550+e15NveqeOg@mail.gmail.com>
	 (sfid-20151103_184304_584889_0EBF3178)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-11-03 at 09:43 -0800, Tim Harvey wrote:

> No surprise that its sold outside the US, but why should that mean it
> should exclude 5GHz support? They all have their regulatory domains
> and my understanding is that the intersection of the reg domain rules
> and card capabilities should dictate if they can operate as an AP per
> 5GHz channel. So I'm trying to understand why this card is dropping
> that capability.
> 

It does have 5 GHz capability, but not for active operation, since
that's not permitted everywhere in the world. The device doesn't want
to rely on software regulatory enforcement, nor are there multiple
versions of the device for different countries, so this is about the
only option left.

johannes
