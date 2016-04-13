Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27682 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbcDMJOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 05:14:46 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Oh, Peter" <poh@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3]  ath10k: add a support of set_tsf on vdev interface
Date: Wed, 13 Apr 2016 09:13:40 +0000
Message-ID: <87ega9ub0c.fsf@kamboji.qca.qualcomm.com> (sfid-20160413_111450_865049_D2FBDAA4)
References: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com>
In-Reply-To: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Mon, 4 Apr 2016 16:19:13 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> 10.2.4 and 10.4 firmware has introduced new function to
> set TSF via vdev parameter.
> set_tsf function can be used to shift TBTT that will help
> avoid its clockdrift which happens when beacons are collided.
>
> Peter Oh (3):
>   ath10k: add a support of set_tsf on vdev interface
>   ath10k: update 10.4 WMI vdev parameters
>   ath10k: enable set_tsf vdev command to WMI 10.4

Series applied, thanks.

-- 
Kalle Valo