Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33963 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbcFTVwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 17:52:09 -0400
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Stand-alone ath10k-ct driver.
Message-ID: <57686587.9050607@candelatech.com> (sfid-20160620_235213_543367_1C77D61D)
Date: Mon, 20 Jun 2016 14:52:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I have made an attempt to provide a stand-alone ath10k driver that should compile
and work against stock 4.7 kernels.  This should provide better support for CT ath10k
firmware without having to apply large numbers of patches.  My 4.7 kernel has only been very lightly tested
to date, and the stand-alone driver is only compile tested.  I will update the
ath-ct repo often as testing progresses on 4.7.

If there are brave souls that want to try it out, I'd appreciate any feedback.

https://github.com/greearb/ath-ct

See the README.txt for some details.  This will require at least some familiarity
with building kernels since I do not have any nice automation to compile against
the current running kernel yet, for instance.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

