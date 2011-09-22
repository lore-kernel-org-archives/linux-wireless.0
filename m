Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42005 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1IVIbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 04:31:21 -0400
Date: Thu, 22 Sep 2011 14:00:39 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix disconnect event reporting
Message-ID: <20110922083038.GA26383@vasanth-laptop> (sfid-20110922_103129_242419_20C0BEDF)
References: <1316534999-26990-1-git-send-email-vthiagar@qca.qualcomm.com> <4E7AE818.5010503@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E7AE818.5010503@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 22, 2011 at 10:47:36AM +0300, Kalle Valo wrote:
> On 09/20/2011 07:09 PM, Vasanthakumar Thiagarajan wrote:
> > Driver does not report disconnect event properly when in connecting state,
> > this leads to issues like not reporting the unavailablity of the
> > connected AP and failures in starting reconnection. Send a disconnect
> > command to target when a disconnect event is received with reason code
> > other than 3 (DISCONNECT_CMD - disconnect request from host) to make the
> > stop trying even after giving disconnect event. There will be one more
> > disconnect event for this disconnect command which will be notified to
> > cfg80211.
> 
> A similar comment in the code would be nice. It's not obvious from the
> code why a separate disconnect command is needed.

Sure.

Vasanth
