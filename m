Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19281 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaKYIIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 03:08:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: move create-ht-cap methods above set-antenna.
References: <1411576506-11815-1-git-send-email-greearb@candelatech.com>
Date: Tue, 25 Nov 2014 10:08:32 +0200
In-Reply-To: <1411576506-11815-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 24 Sep 2014 09:35:05
	-0700")
Message-ID: <874mtn3dof.fsf@kamboji.qca.qualcomm.com> (sfid-20141125_090841_407968_9725E69B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> We will need to use these in set-antenna, so move them
> so that we do not have to define the method signatures.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

I'm dropping these two patches. Please resend once we figure out how to
handle the band updated.

-- 
Kalle Valo
