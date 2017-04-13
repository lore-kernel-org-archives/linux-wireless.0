Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17260 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbdDMMsF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:48:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] wil6210: fix sequence for scan-abort during reset
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1491393494-11816-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1491393494-11816-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <752a48d0f3834e95b31123e43a02b4d9@euamsexm01a.eu.qualcomm.com> (sfid-20170413_144809_866531_1EFA99AD)
Date: Thu, 13 Apr 2017 14:47:32 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> 
> Communication with FW must be done before wil->status
> is initialized in order to properly handle cases where
> communication with FW halts during reset sequence.
> 
> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

11 patches applied to ath-next branch of ath.git, thanks.

82e9f6465554 wil6210: fix sequence for scan-abort during reset
8b068c032a5c wil6210: restore power save state after internal FW reset
52a457020a89 wil6210: support 8KB RX buffers
90ffabb08b7d wil6210: align to latest auto generated wmi.h
b819447dfc4b wil6210: fix protection against connections during reset
a3839fbcf035 wil6210: protect against sporadic interrupt during suspend flow
4d4f8132f72b wil6210: fix check for sparrow D0 FW file
0f6edfe2bbbb wil6210: fix memory access violation in wil_memcpy_from/toio_32
bd50e2688a78 wil6210: remove HALP voting in debugfs ioblob
98a830a98dab wil6210: fix array out of bounds access in pmc
3161adddf309 wil6210: prevent access to 11AD device if resume fails

-- 
https://patchwork.kernel.org/patch/9663843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
