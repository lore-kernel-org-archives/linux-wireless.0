Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42064 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3BSCPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 21:15:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20770.57339.20017.225929@gargle.gargle.HOWL> (sfid-20130219_031546_571909_16A50F6F)
Date: Tue, 19 Feb 2013 07:44:19 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
In-Reply-To: <511BC243.8010409@candelatech.com>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> On 02/11/2013 04:11 PM, Sujith Manoharan wrote:
> > Ben Greear wrote:
> >> axq-qnum:                    2          3         1         0
> >> axq-depth:                   0          0         0         0
> >> axq-ampdu_depth:             0          0         0         0
> >> axq-stopped                  1          0         0         0
> >> tx-in-progress               0          0         0         0
> >> pending-frames             125          0         0         0
> >
> > The frames appear to be stuck in the pending queue.
> 
> Any ideas on what code to go poking at?

xmit.c would be a good place. Can you also post the kernel log with some
debugging information ? debug=0x8f49 would be good.

Sujith
