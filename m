Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1286 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1I1ROz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 13:14:55 -0400
Message-ID: <4E834DDA.1030608@qca.qualcomm.com> (sfid-20110928_191458_240850_1F295BF6)
Date: Wed, 28 Sep 2011 19:39:54 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath6kl: add prefix parameter to ath6kl_dbg_dump()
References: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
In-Reply-To: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 02:30 PM, Kalle Valo wrote:
> Makes it easier to recognise longs dumps.
> 
> Obligatory screenshot using "rx" prefix:
> 
> ath6kl: ath6kl_rx
> rx 00000000: 10 10 00 00 00 00 08 30 00 00 00 00 00 00 f9 0b  .......0........
> rx 00000010: 2c 44 08 30 00 00 f9 0b 0c a4 02 00 00 00 73 d2  ,D.0..........s.
> rx 00000020: 94 00 f9 0b 04 8c 01 00 02 00 07 02 02 00 f9 0b  ................

All four applied.

Kalle
