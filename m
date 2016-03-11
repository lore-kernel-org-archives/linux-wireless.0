Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48681 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbcCKMNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 07:13:37 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Oh, Peter" <poh@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6] ath10k: set MAC timestamp in management Rx frame
Date: Fri, 11 Mar 2016 12:13:32 +0000
Message-ID: <878u1pnrf7.fsf@kamboji.qca.qualcomm.com> (sfid-20160311_131340_658268_E9F2952B)
References: <5c9a7c5d47974cf3e72cd114e140027e2a4bbdab.1456854314.git.poh@qca.qualcomm.com>
In-Reply-To: <5c9a7c5d47974cf3e72cd114e140027e2a4bbdab.1456854314.git.poh@qca.qualcomm.com>
	(Peter Oh's message of "Tue, 1 Mar 2016 09:52:49 -0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Check and set Rx MAC timestamp when firmware indicates it.
> Firmware adds it in Rx beacon frame only at this moment.
> Driver and mac80211 may utilize it to detect such clockdrift
> or beacon collision and use the result for beacon collision
> avoidance.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo