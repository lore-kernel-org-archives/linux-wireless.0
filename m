Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54841 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966402AbcIZSB1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 14:01:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: hostap: Delete an unnecessary jump label in prism2_ioctl_priv_hostapd()
References: <65ed528f-7ec5-a0f2-6219-3e63a78ca0ee@users.sourceforge.net>
        <20160926150656.213D961568@smtp.codeaurora.org>
        <88d5023a-9a59-ab36-8c6c-a146cae803b5@users.sourceforge.net>
Date: Mon, 26 Sep 2016 21:01:21 +0300
In-Reply-To: <88d5023a-9a59-ab36-8c6c-a146cae803b5@users.sourceforge.net> (SF
        Markus Elfring's message of "Mon, 26 Sep 2016 18:03:00 +0200")
Message-ID: <874m52zgjy.fsf@kamboji.qca.qualcomm.com> (sfid-20160926_200149_319467_8387BE27)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SF Markus Elfring <elfring@users.sourceforge.net> writes:

>> 9291771 [2/3] hostap: Delete an unnecessary jump label in prism2_ioctl_priv_hostapd()
>> 9291775 [3/3] hostap: Delete unnecessary initialisations for the variable "ret"
>> 
>> Reason: The benefit is not clear.
>
> How do you think about to reduce the source code a bit at these places?

hostap is an obsolete driver, it's waste of time doing style fixes to it
as nobody maintains it anymore.

-- 
Kalle Valo
