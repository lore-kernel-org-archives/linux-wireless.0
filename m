Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4694 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbcFGL3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 07:29:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: add QCA9887 chipset support
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1463755272-12912-1-git-send-email-sven.eckelmann@open-mesh.com>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
CC: <ath10k@lists.infradead.org>,
	Sven Eckelmann <sven.eckelmann@open-mesh.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <d77ac566725940fa90cd014198ffb030@euamsexm01a.eu.qualcomm.com> (sfid-20160607_132945_383990_9A7E5F7D)
Date: Tue, 7 Jun 2016 13:29:19 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@open-mesh.com> wrote:
> Add the hardware name, revision, firmware names and update the pci_id
> table.
> 
> QA9887 HW1.0 is supposed to be similar to QCA988X HW2.0 . Details about
> he firmware interface are currently unknown.
> 
> Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

6fd3dd716091 ath10k: add QCA9887 chipset support
6847f9673391 ath10k: add board data download from target

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9129717/

