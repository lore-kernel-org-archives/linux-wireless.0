Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdFIJZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 05:25:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/11] wireless: ipw2x00: convert to use DRIVER_ATTR_RW
References: <20170609090314.13991-1-gregkh@linuxfoundation.org>
        <20170609090314.13991-7-gregkh@linuxfoundation.org>
Date: Fri, 09 Jun 2017 12:25:44 +0300
In-Reply-To: <20170609090314.13991-7-gregkh@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Fri, 9 Jun 2017 11:03:10 +0200")
Message-ID: <87h8zp4inb.fsf@codeaurora.org> (sfid-20170609_112610_833651_A1D6BE10)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> We are trying to get rid of DRIVER_ATTR(), and the ipw2x00 driver's
> attributes can be trivially changed to use DRIVER_ATTR_RW().
>
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: <linux-wireless@vger.kernel.org>
> Cc: <netdev@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Looks good to me. I assume that I should take this, but let me know if
you are planning to push this via your trees instead. Either way is fine
for me, I'm not expecting any conflicts here.

-- 
Kalle Valo
