Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42146 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbbAPMWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 07:22:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/8] ath10k: add multi-channel support
References: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 16 Jan 2015 14:22:28 +0200
In-Reply-To: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 Jan 2015 12:14:01 +0100")
Message-ID: <877fwmnce3.fsf@kamboji.qca.qualcomm.com> (sfid-20150116_132241_521282_3547E0DD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New wmi-tlv firmware and new hardware will support
> multi-channel operation.
>
> This prepares the driver by implementing chanctx,
> improves tx queue locking and introduces initial
> interface combinations.
>
> I'm posting this as an RFC first because I'd like
> to get some early feedback (if possible) while I
> upstream other patches this patchset is basing on.
>
>
> Michal Kazior (8):
>   ath10k: defer AP self-peer removal wait
>   ath10k: allow empty ssid vdev config
>   ath10k: implement chanctx API
>   ath10k: implement adaptive qcs command
>   ath10k: protect ar->arvifs linking with data_lock
>   ath10k: rework tx queue locking
>   ath10k: implement tx pause wmi event
>   ath10k: add proper wmi-tlv combinations

>From a quick review looks good to me. Sorry for taking so long with
this.

-- 
Kalle Valo
