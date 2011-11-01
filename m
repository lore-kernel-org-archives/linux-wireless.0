Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8502 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1KAF35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 01:29:57 -0400
Date: Tue, 1 Nov 2011 10:59:33 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 00/31] ath6kl Add multiple vif support
Message-ID: <20111101052932.GA7966@vasanth-laptop> (sfid-20111101_063008_317915_11D34D1D)
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com> <4EA7B536.70107@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4EA7B536.70107@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2011 at 10:22:30AM +0300, Kalle Valo wrote:
> On 10/25/2011 05:03 PM, Vasanthakumar Thiagarajan wrote:
> > This patch set adds basic infrastructure for multiple
> > virtual interface. As configuring the firmware with more than one
> > vif causes random target assert, the number of supported vifs is
> > restricted to 1 for now. I would like to thank Vivek Natarajan
> > (nataraja@qca.qualcomm.com) for his inital work in this area and
> > Arthi Thiruvengadam (athiruve@qca.qualcomm.com) for finding some
> > critical bugs.
> 
> I saw the lockdep warning below after I loaded the module and connected
> to an AP. But the driver still functioned normally.

Sorry, i did not test with lockdep warning enabled, i'll look into
this. Thanks!

Vasanth

