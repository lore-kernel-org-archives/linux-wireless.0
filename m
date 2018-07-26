Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34852 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbeGZHXB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 03:23:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        ath9k-devel@qca.qualcomm.com, linuxwifi@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1 2/4] ath9k: Remove unnecessary include of <linux/pci-aspm.h>
References: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
        <153254835812.92573.3566522887325831923.stgit@bhelgaas-glaptop.roam.corp.google.com>
Date: Thu, 26 Jul 2018 09:07:40 +0300
In-Reply-To: <153254835812.92573.3566522887325831923.stgit@bhelgaas-glaptop.roam.corp.google.com>
        (Bjorn Helgaas's message of "Wed, 25 Jul 2018 14:52:38 -0500")
Message-ID: <874lgmv8b7.fsf@kamboji.qca.qualcomm.com> (sfid-20180726_080820_284103_70A879B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Helgaas <helgaas@kernel.org> writes:

> From: Bjorn Helgaas <bhelgaas@google.com>
>
> The ath9k driver doesn't need anything provided by pci-aspm.h, so remove
> the unnecessary include of it.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Looks good to me and feel free to take via your tree.

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
