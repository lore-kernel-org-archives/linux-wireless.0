Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59061 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaJDHqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2014 03:46:32 -0400
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <21551.42474.535540.368033@gargle.gargle.HOWL> (sfid-20141004_094646_189022_731FC3FC)
Date: Sat, 4 Oct 2014 13:16:50 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ben Greear <greearb@candelatech.com>
Cc: "ath9k-devel\@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rmanohar@qti.qualcomm.com
Subject: Re: 3.17 regression, ath9k: Summarize hw state per channel context
In-Reply-To: <542F124C.50406@candelatech.com>
References: <542F124C.50406@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Took a while, but I found the regression that has been bugging me.
> 
> This is on stock kernel, with hand-patched fixup from Felix that fixes
> crash related to minstrel (patch made it upstream later, so that isn't
> a current problem).
> 
> The test case is easily reproducible on my systems.  I'm not sure
> all the details matter, but this happens to be my test case
> at the moment:
> 
> 32-bit Fedora OS, latest supplicant, etc.  ath9k NIC.

Does this happen with latest wireless-testing ?

Sujith
