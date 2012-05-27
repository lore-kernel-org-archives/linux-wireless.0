Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36923 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2E0CQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 22:16:26 -0400
Message-ID: <4FC18E6E.4020707@candelatech.com> (sfid-20120527_041649_544907_5D5C41D0)
Date: Sat, 26 May 2012 19:16:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com> <20417.35821.91808.2702@gargle.gargle.HOWL> <20417.36056.95300.690329@gargle.gargle.HOWL>
In-Reply-To: <20417.36056.95300.690329@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2012 07:09 PM, Sujith Manoharan wrote:
> Sujith Manoharan wrote:
>> Odd. I get low numbers with a DB120 running OpenWRT (git HEAD).
>>
>> TCP TX - ~260 Mbps.
>> TCP RX - ~160 Mbps.
>>
>> UDP RX - ~240 Mbps.
>> UDP TX - iperf borks and doesn't display anything.

Maybe NAT won't let it through, if this is coming downstream?

For that matter, from what perspective is the TX or RX?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
