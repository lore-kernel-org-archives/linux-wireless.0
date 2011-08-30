Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35178 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1H3B7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 21:59:12 -0400
Subject: Re: BQL crap and wireless
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=US-ASCII
From: Andrew McGregor <andrewmcgr@gmail.com>
In-Reply-To: <4E5C3B47.1050809@freedesktop.org>
Date: Tue, 30 Aug 2011 13:59:05 +1200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	Tom Herbert <therbert@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Message-Id: <903AA8A8-9ACD-44FB-9BA8-50137359EC2B@gmail.com> (sfid-20110830_035917_776555_17617E26)
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com> <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com> <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com> <4E5C3B47.1050809@freedesktop.org>
To: Jim Gettys <jg@freedesktop.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 30/08/2011, at 1:22 PM, Jim Gettys wrote:

> The gotcha is we don't have a AQM algorithm known to work in
> the face of the highly dynamic bandwidth variation that is wireless

It's worse than highly dynamic... the bandwidth may be completely undefined moment to moment, as it is dependent on both the wireless environment, which varies on timescales that can be about equal to a packet transmit time, and on the traffic mix.  There's about 30 ms of correlation time at best.

>  This was/is
> the great surprise to me as I had always thought of AQM as a property of
> internet routers, not hosts.

There's no distinction in the forwarding plane, every router is a host, every host is a router.

Andrew