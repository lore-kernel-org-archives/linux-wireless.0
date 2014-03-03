Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64895 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaCCPjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 10:39:54 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k:  add vdev-id, return code to error codes
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
Date: Mon, 3 Mar 2014 17:39:48 +0200
In-Reply-To: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 13 Feb 2014 11:09:21
	-0800")
Message-ID: <87r46j47gb.fsf@kamboji.qca.qualcomm.com> (sfid-20140303_163957_877789_557884A2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> When using multiple vdevs (stations, aps, etc), it is
> nice to be able to associate log messages with specific
> interfaces.  So, add vdev-id to most logging messages.
> Add return code as well, where it was missing.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, applied with the changes we discussed.

-- 
Kalle Valo
