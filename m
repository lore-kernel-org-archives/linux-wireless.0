Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50408 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdHIMY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 08:24:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: james@nurealm.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless drivers fail to report link speed?
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
Date: Wed, 09 Aug 2017 15:24:50 +0300
In-Reply-To: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net> (James
        Feeney's message of "Tue, 8 Aug 2017 13:07:17 -0600")
Message-ID: <871soludwt.fsf@purkki.adurom.net> (sfid-20170809_142502_097429_E022E2AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Feeney <james@nurealm.net> writes:

> Would you please look at kernel bug report "Since 4.12 - bonding module not
> working with wireless drivers", and tell me if you know why the kernel ethtool
> does not receive a speed report from the wireless drivers?
>
>  https://bugzilla.kernel.org/show_bug.cgi?id=196547

Have you reported this on netdev (CCing linux-wireless, David Miller and
the patch authors)? I think the offending bonding patch should be
reverted but first it needs to be properly reported on the mailing list.
Most people don't really follow bugzilla.

-- 
Kalle Valo
