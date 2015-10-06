Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4263 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbJFLsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 07:48:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: use Rx decap mode configured when driver registered
References: <1443042740-31928-1-git-send-email-poh@qca.qualcomm.com>
Date: Tue, 6 Oct 2015 14:47:59 +0300
In-Reply-To: <1443042740-31928-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Wed, 23 Sep 2015 14:12:20 -0700")
Message-ID: <878u7g2p74.fsf@kamboji.qca.qualcomm.com> (sfid-20151006_134813_916759_03A5D102)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> ath10k is using Native WiFi mode as default mode for both of
> Tx and Rx path, but it could be changed when driver registers
> with a module parameter for specific purpose such as mesh.
>
> The Rx decap mode sent to firmware during WMI initialization should
> use the same mode that driver configured at its registration stage
> in case of using raw mode, so that host driver receives MAC frame
> header containing necessary fields such as QoS and Mesh Control
> and uses them in right way to make data traffic work.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
