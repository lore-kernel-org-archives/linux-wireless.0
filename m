Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbcDDO5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 10:57:45 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Oh, Peter" <poh@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: parse Rx MAC timestamp in mgmt frame for FW
 10.4
Date: Mon, 4 Apr 2016 14:57:40 +0000
Message-ID: <87zit9ctgb.fsf@kamboji.qca.qualcomm.com> (sfid-20160404_165747_794770_E147D8D6)
References: <20caae0068a19c546f87ef4a25e3651af92c02ab.1458686620.git.poh@qca.qualcomm.com>
In-Reply-To: <20caae0068a19c546f87ef4a25e3651af92c02ab.1458686620.git.poh@qca.qualcomm.com>
	(Peter Oh's message of "Tue, 22 Mar 2016 15:44:53 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Check and parse Rx MAC timestamp when firmware sets its flag
> to status variable.
> 10.4 firmware adds it in Rx beacon frame only at this moment.
> Drivers and mac80211 may utilize it to detect such clockdrift
> or beacon collision and use the result for beacon collision
> avoidance.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo