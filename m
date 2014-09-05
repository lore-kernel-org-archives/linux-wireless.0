Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:60980 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaIENEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 09:04:13 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so1032849igb.8
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 06:04:12 -0700 (PDT)
Date: Fri, 5 Sep 2014 09:03:25 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dani Camps <danicamps81@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wmediumd performance penalty
Message-ID: <20140905130325.GA26808@localhost> (sfid-20140905_150417_019868_A86E99BE)
References: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com>
 <1409597534.2703.9.camel@jlt4.sipsolutions.net>
 <CAD3NH5Wimu9muPeL-zFrw=u1G3Q+8749cj0SYUmeQuLF6LKibQ@mail.gmail.com>
 <1409644512.1808.2.camel@jlt4.sipsolutions.net>
 <CAD3NH5XEfHU7KMWwrmZdZz9LKP_86b4EFogpHrnC+AhREHjOPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD3NH5XEfHU7KMWwrmZdZz9LKP_86b4EFogpHrnC+AhREHjOPw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2014 at 10:06:30AM +0200, Dani Camps wrote:
> Hi,
> 
> OK, then the results I am getting are indeed surprising. To test
> bandwidth I am using an iperf UDP transfer of 100Mbps and around 30
> Mbps is all it gets (without wmediumd).
> 
> I will further test only mac80211_hwsim (without wmediumd), which I
> believe can be used to set up topologies as well with the group
> feature as described here:
> https://github.com/cozybit/open80211s/wiki/HwsimTestTemplate

Indeed you can.

For what it's worth, although I can't speak for wmediumd at the moment,
in the precursor to it that I wrote, I got about 25 Mbps achieved with
a phy rate of 54 Mbps when simulating the physical layer, which I think
is pretty close to real world overhead in non-agg case.  With plain old
mac80211_hwsim you can get several Gbps.

-- 
Bob Copeland %% www.bobcopeland.com
