Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755182AbeCHIks (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 03:40:48 -0500
Received: from x230.qca.qualcomm.com (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB1266024C
        for <linux-wireless@vger.kernel.org>; Thu,  8 Mar 2018 08:40:46 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: Variable-length arrays considered bad
Date: Thu, 08 Mar 2018 10:40:44 +0200
Message-ID: <87zi3j9cz7.fsf@codeaurora.org> (sfid-20180308_094052_456787_72248763)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

in an lkml discussion[1] it was mentioned that variable-length arrays
should not be used. Few warnings were found[2] from wireless:

drivers/net/wireless/ath/ath9k/dfs.c:104:2: warning: ISO C90 forbids variable length array 'max_bin' [-Wvla]
drivers/net/wireless/rsi/rsi_91x_sdio.c:570:2: warning: ISO C90 forbids variable length array 'temp_buf' [-Wvla]

Patches welcome.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

[2] http://paste.ubuntu.com/p/srQxwPQS9s/

-- 
Kalle Valo
