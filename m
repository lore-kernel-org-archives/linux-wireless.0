Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62522 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaJFQpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 12:45:55 -0400
Date: Mon, 6 Oct 2014 22:17:32 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: Add tracing for tx and rx frames
Message-ID: <20141006164730.GA362@qca.qualcomm.com> (sfid-20141006_184559_371673_B5017A4F)
References: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com>
 <21554.39629.93084.875971@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <21554.39629.93084.875971@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2014 at 07:06:13PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > These changes are the extension of pktlog for dumping tx and rx
> > frames to user space. I am rebasing Michal's work on top of pktlog.
> > 
> > -Rajkumar
> > 
> > Michal Kazior (3):
> >   ath10k: add tracepoint for wmi mgmt tx frames
> >   ath10k: add tracepoint for wmi bcn tx
> >   ath10k: add htt rx tracepoints
> 
> These tracepoints look really similar, maybe you can
> group them into an event class.
>
Nice catch. Will send updated patches.

-Rajkumar
