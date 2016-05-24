Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59768 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbcEXRzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 13:55:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath10k: Fix legacy rate packet debug messages
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1463474131-26835-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <98b2e947a9ec454cb16e0c26dde6f618@euamsexm01a.eu.qualcomm.com> (sfid-20160524_195520_999727_0CD78719)
Date: Tue, 24 May 2016 19:55:08 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Legacy rate packets may not necessarily be having a rx status
> flag of '0' always, for example management frame have flags
> like RX_FLAG_ONLY_MONITOR / RX_FLAG_MACTIME_END also set
> 
> Just check 'VHT' and 'HT' flags are not set , and simply clasify it as
> legacy rate packets
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath.git:

026441c9d4ff ath10k: fix legacy rate packet debug messages

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9110621/

