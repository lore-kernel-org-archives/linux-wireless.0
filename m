Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48449 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3BUBjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 20:39:51 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20773.31380.740958.31338@gargle.gargle.HOWL> (sfid-20130221_023954_598638_CD42F8E8)
Date: Thu, 21 Feb 2013 07:08:28 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
In-Reply-To: <51257304.10109@candelatech.com>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
	<20770.57339.20017.225929@gargle.gargle.HOWL>
	<51255360.6060603@candelatech.com>
	<51257304.10109@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> For instance, in this case, why do we have pending frames, the axq-stopped,
> and no axq depth?  Is that an invalid state to begin with?  Once
> it gets in the hung state, those numbers never change.  I'd assume
> something should be poking more packets out of the pending frames
> down into the axq logic?

Something is broken in the xmit path, definitely.

Sujith
