Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:37027 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab2DJKJ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 06:09:56 -0400
Message-ID: <4F8406F0.9090900@neratec.com> (sfid-20120410_120959_621200_EAD28278)
Date: Tue, 10 Apr 2012 12:09:52 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Chadd, Adrian" <achadd@qca.qualcomm.com>
CC: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, rodrigue@qca.qualcomm.com,
	achadd@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [PATCH 1/3] ath9k: add DFS pattern detector
References: <1333466151-6570-1-git-send-email-zefir.kurtisi@neratec.com> <1333466151-6570-2-git-send-email-zefir.kurtisi@neratec.com> <CAJ-Vmon-kgy8kM=Q=4jBJFfMuMxprwjrj6Za_UyLWLEwYtMTEw@mail.gmail.com>
In-Reply-To: <CAJ-Vmon-kgy8kM=Q=4jBJFfMuMxprwjrj6Za_UyLWLEwYtMTEw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/2012 01:35 AM, Adrian Chadd wrote:
> [top post]
> 
> I think this is a good starting point. Let's aim to get this into the
> tree and then start working on some further testing and debugging
> APIs.
> 
> Thanks so much for working on this!
> 
> 
> 
> Adrian
> 
Thanks for looking at it, Adrian.

As for the APIs, I have some debugfs based statistics used for pulse and
pattern detection evaluation that I'll post as soon as the detector
module gets accepted.

Since DFS testing is a new topic anyhow, if you have some existing APIs
used in your QCA test-lab, I'd suggest to adopt them for ath9k.
Otherwise let's pool together and develop some sane and easy-to-use test
framework to share the enormous testing and/or certification efforts
(though realistically DFS testing will never be plug-and-playable to be
performed by common developers outside full-blown testing labs :-().


Thanks, Zefir

