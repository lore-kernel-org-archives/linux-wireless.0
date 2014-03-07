Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29864 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaCGIRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 03:17:44 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: do not overwrite max_antenna_gain
References: <1394021433-19376-1-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 7 Mar 2014 10:17:39 +0200
In-Reply-To: <1394021433-19376-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 5 Mar 2014 13:10:33 +0100")
Message-ID: <878usmpgm4.fsf@kamboji.qca.qualcomm.com> (sfid-20140307_091748_476873_824BE484)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> From: Marek Puzyniak <marek.puzyniak@tieto.com>
>
> Seems like we have an old bug, where we incidently overwrites
> the max_antenna_gain we pass to firmware, with zero value.
>
> End of all we are artifically reducing the output power.
>
> This patch removes the excessive assignment on max_antenna_gain,
> which is being provided by regulatory domain, and consequently
> improves the tx power.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
