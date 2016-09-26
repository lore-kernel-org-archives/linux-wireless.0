Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:52326 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966362AbcIZQDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 12:03:13 -0400
Subject: Re: hostap: Delete an unnecessary jump label in
 prism2_ioctl_priv_hostapd()
To: Kalle Valo <kvalo@codeaurora.org>
References: <65ed528f-7ec5-a0f2-6219-3e63a78ca0ee@users.sourceforge.net>
 <20160926150656.213D961568@smtp.codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <88d5023a-9a59-ab36-8c6c-a146cae803b5@users.sourceforge.net> (sfid-20160926_180318_096933_0F6178F0)
Date: Mon, 26 Sep 2016 18:03:00 +0200
MIME-Version: 1.0
In-Reply-To: <20160926150656.213D961568@smtp.codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 9291771 [2/3] hostap: Delete an unnecessary jump label in prism2_ioctl_priv_hostapd()
> 9291775 [3/3] hostap: Delete unnecessary initialisations for the variable "ret"
> 
> Reason: The benefit is not clear.

How do you think about to reduce the source code a bit at these places?

Regards,
Markus
