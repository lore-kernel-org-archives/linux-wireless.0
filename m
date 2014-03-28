Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14790 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaC1HoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:44:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4 v2] ath10k:  better firmware loading error messages
References: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
	<1395688844-24640-2-git-send-email-greearb@candelatech.com>
Date: Fri, 28 Mar 2014 09:43:57 +0200
In-Reply-To: <1395688844-24640-2-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 24 Mar 2014 12:20:41
	-0700")
Message-ID: <8738i2ydhe.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_084408_660156_2A2FDDF9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Let user know the name of the board file if it is not
> found, and make it easier to determine the firmware
> api being used.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, patches 2 and 3 applied. Patches 1 and 4 dropped.

-- 
Kalle Valo
