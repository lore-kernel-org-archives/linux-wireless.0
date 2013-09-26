Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3944 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab3IZNFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 09:05:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/13] ath10k: dual-firmware support (MAIN and 10.X)
References: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 26 Sep 2013 16:05:41 +0300
In-Reply-To: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Thu, 26 Sep 2013 11:29:39 +0200")
Message-ID: <87y56jpwbe.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_150918_195402_6B10F8F9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This patch-set adds framework for dynamic support of 10.X FW branch.
>
> The major changes covered by this work:
> * dynamic WMI structures
> * WMI cmd/event definitions from 10.x FW track
> * memory host chunks feature
> * management frames path over WMI for 10.x
> * WMI RX events handling for MAIN and 10.X split
> * target config split (LARGE AP feature for 10.x)
> * scan start sctructure split
> * dynamic VDEV and PDEV parameters structures
>
> Changes in v2 
> (review comments from Kalle and Michal):
> * WMI cmd, pdev and vdev params names trimmed
> * ath10k_wmi_cmd_init() exposed only
> * few 'if' statements simplifications
> * 10.x mgmt frames over WMI - 'BUG: scheduling while atomic' fixed

This is looking very good now, I had only had few nitpicks which I found
while reviewing this.

-- 
Kalle Valo
