Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46617 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaJFNf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 09:35:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21554.39629.93084.875971@gargle.gargle.HOWL> (sfid-20141006_153530_384817_EC8A39AF)
Date: Mon, 6 Oct 2014 19:06:13 +0530
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: Add tracing for tx and rx frames
In-Reply-To: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> These changes are the extension of pktlog for dumping tx and rx
> frames to user space. I am rebasing Michal's work on top of pktlog.
> 
> -Rajkumar
> 
> Michal Kazior (3):
>   ath10k: add tracepoint for wmi mgmt tx frames
>   ath10k: add tracepoint for wmi bcn tx
>   ath10k: add htt rx tracepoints

These tracepoints look really similar, maybe you can
group them into an event class.

Sujith
