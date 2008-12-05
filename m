Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46004 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYLEC2z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 21:28:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 18:28:55 -0800
Date: Thu, 4 Dec 2008 18:28:53 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Brian <bnc@astronomicalresearchaustralia.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: 2.6.28-rc7-wl
Message-ID: <20081205022853.GO5970@tesla> (sfid-20081205_032859_519508_95EDC0F4)
References: <20081203002404.GA22789@tuxdriver.com> <20081203212255.GB4263@tuxdriver.com> <43e72e890812031414m6a5782e7ga8eed8d91fe056b2@mail.gmail.com> <49370F49.2090602@astronomicalresearchaustralia.org> <20081204023228.GT6522@tesla> <49378DCB.3080401@astronomicalresearchaustralia.org> <20081204191933.GB5970@tesla> <49385507.3090705@astronomicalresearchaustralia.org> <20081204224300.GN5970@tesla> <493869E1.60207@astronomicalresearchaustralia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <493869E1.60207@astronomicalresearchaustralia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2008 at 03:38:09PM -0800, Brian wrote:
> 
> 
> Luis,
> 
> >> So I think the driver could be fine, it could be application specific.
> >> Will also do a search of the NX site and see if they have any problems.
> >>
> >> Will let you know how I go.
> >
> > I see.. What is NX?
> http://www.nomachine.com/
> NX is really great and is easily the best remote control software.
> While I can get by with krdc I want to use NX if I can.
> 
> We run tests against ath9k over hours too and
> > I don't think we've seen this memory hog issue. But if your userspace
> > application is hogging up application your kernel shoulod not panic,
> > unless of course some -ENOMEM as part of your drivers is not being
> > handled correctly. But the patches merged recently actually handle this
> > for ath9k :) I at least have tested it with mem=200 and even using the
> > swiotlb.
> >
> Yes I saw that you had included the -ENOMEM fix, so I was very hopeful
> that the problem would go away.
> I must say the difference between rc6 and rc7 is really significant.
> Things are quicker and more stable for all the normal operations.
> I just do not see what is different about NX, I might try running
> wireshark on it. If you could fire up NX and it fails then at least we
> could say that it is not specific to my machine.
> I should also point out that when researching this problem on the web I
> found that hundreds of people were having the same freezing problem.
> 
> My krdc has been running for 30mins with no problems, but the memory is
> going up.
> 
> Back in a bit

So do some other test -- run bitorrent, or iperf. That should rule out
ath9k.

To test if its NX try testing it over a wired ethernet connection.

  Luis
