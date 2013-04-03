Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pikachu.3ti.be ([188.40.111.73]:52305 "EHLO pikachu.3ti.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763182Ab3DCJ0Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 05:26:16 -0400
Date: Wed, 3 Apr 2013 11:16:07 +0200 (CEST)
From: Dag Wieers <dag@wieers.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: BCM4321 (b43) on AppleTV (1st gen)
In-Reply-To: <CACna6rwrq1qF4Rmf81OhO7jrXouUdjcAvnMtJcnCb4s=zm7a2w@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1304031105330.26996@pikachu.3ti.be> (sfid-20130403_112632_582169_E97FD760)
References: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be> <CACna6rwrq1qF4Rmf81OhO7jrXouUdjcAvnMtJcnCb4s=zm7a2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="683428207-1747794359-1364980053=:26996"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--683428207-1747794359-1364980053=:26996
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.02.1304031109101.26996@pikachu.3ti.be>

On Wed, 3 Apr 2013, Rafa³ Mi³ecki wrote:

> It's terribly late reply, but only recently I've time to plug in my
> old BCM4321/BCM4322 cards and test them. There were few regressions
> affecting BCM4322, but nothing BCM4321 related (there are many
> differences between them).
>
> In my env I can't get more than 22Mb/s using my BCM4322. It's
> 2,75MB/s, so your 3MB/s is even better result than mine. The problem
> is that b43 doesn't support 802.11n features, so it can't work any
> faster. Values around 2-3MB/s is maximum you can get from 802.11g.

I can see from the access point that it often indicates the system to be 
connected at 54Mbps, but I never seem to get that throughput. However the 
numbers I indicate are SFTP transfers with some overhead, but also 
buffering (so it usually starts off quite fast and then the number drops 
rapidly). Not very scientific so it might as well be 2.75MB/s :)


> I plan to add support for new devices, then 5GHz, then maybe I'll take
> a look at 802.11n standard. So unfortunately there's a long way before
> we can support higher speeds :(

If it helps, I can offer two of this mini PCI adapters to any developer 
interested in improving the support of the BCM4321.


> P.S.
> I suggest Cc-ing b43 mailing list in the future ;)

Done :)

Thanks for the feedback,
-- 
-- dag wieers, dag@wieers.com, http://dag.wieers.com/
-- dagit linux solutions, info@dagit.net, http://dagit.net/

[Any errors in spelling, tact or fact are transmission errors]
--683428207-1747794359-1364980053=:26996--
