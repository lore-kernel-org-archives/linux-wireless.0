Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54834 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaC1O7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 10:59:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: Re: [PATCH v2] ath10k:  add the Rx rate in FW stats
References: <1395441560-6028-1-git-send-email-greearb@candelatech.com>
Date: Fri, 28 Mar 2014 16:59:10 +0200
In-Reply-To: <1395441560-6028-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Fri, 21 Mar 2014 15:39:20
	-0700")
Message-ID: <87bnwqv075.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_155921_838470_EC289BAC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> FW stats does provide the Rx rate information. Add this.
> Tested with firmware 10x firmware.
>
> Increase buffer size so more peers can be shown.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v2:  Re-work Chun-Yeow's patch to hopefully be backwards compat
>      with pre 10.x firmware.  I tested on modified 10x firmware.

Thanks, applied.

-- 
Kalle Valo
