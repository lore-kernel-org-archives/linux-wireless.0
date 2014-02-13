Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64298 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBMQFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 11:05:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
References: <cover.1389904166.git.agordeev@redhat.com>
	<ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
	<20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
Date: Thu, 13 Feb 2014 18:04:57 +0200
In-Reply-To: <20140130134819.GA31909@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Thu, 30 Jan 2014 14:48:20 +0100")
Message-ID: <87vbwj6lsm.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_170533_830665_947E2D43)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexander Gordeev <agordeev@redhat.com> writes:

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Thanks, all three patches applied to my ath.git tree.

-- 
Kalle Valo
