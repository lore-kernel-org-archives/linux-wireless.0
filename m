Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:48367 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbeGYWMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 18:12:55 -0400
Message-ID: <285792564f164b40609f696616ff0169c46ceb8c.camel@intel.com> (sfid-20180725_225947_863959_F31C8562)
Subject: Re: [PATCH v1 3/4] iwlwifi: Remove unnecessary include of
 <linux/pci-aspm.h>
From: Luciano Coelho <luciano.coelho@intel.com>
To: Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        ath9k-devel@qca.qualcomm.com, linuxwifi@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Wed, 25 Jul 2018 23:59:23 +0300
In-Reply-To: <153254836793.92573.16383045269302376209.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <153254813164.92573.10755585465477668768.stgit@bhelgaas-glaptop.roam.corp.google.com>
         <153254836793.92573.16383045269302376209.stgit@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-25 at 14:52 -0500, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> This part of the iwlwifi driver doesn't need anything provided by
> pci-aspm.h, so remove the unnecessary include of it.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---

Acked-by: Luca Coelho <luciano.coelho@intel.com>

Thanks!

--
Cheers,
Luca.
