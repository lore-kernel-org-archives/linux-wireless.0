Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:42180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdIFXbM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 19:31:12 -0400
Date: Wed, 06 Sep 2017 16:31:11 -0700 (PDT)
Message-Id: <20170906.163111.1134793014413389479.davem@davemloft.net> (sfid-20170907_013135_932498_28E28E15)
To: torvalds@linux-foundation.org
Cc: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, kvalo@codeaurora.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFw0KNTKFrRHk5hthDGTGgL9BGt9G=x_m9Tz7m_-pN+NoA@mail.gmail.com>
References: <20170905.214143.826912481689443792.davem@davemloft.net>
        <CA+55aFw0KNTKFrRHk5hthDGTGgL9BGt9G=x_m9Tz7m_-pN+NoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Sep 2017 16:27:15 -0700

> This pull request completely breaks Intel wireless for me.
> 
> This is my trusty old XPS 13 (9350), using Intel Wireless 8260 (rev 3a).
> 
> That remains a very standard Intel machine with absolutely zero odd
> things going on.
> 
> The firmware is iwlwifi-8000C-28.ucode from
> iwl7260-firmware-25.30.13.0-75.fc26.noarch, and the kernel reports
 ...

Johannes and other Intel folks please look into this.
