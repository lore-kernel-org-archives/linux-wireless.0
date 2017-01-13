Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29354 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdAMIVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 03:21:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,12/13] wil6210: set dma mask to reflect device capability
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1484226365-10433-13-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-13-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <4039bae3b41f4655b33e83a3d949e96c@euamsexm01a.eu.qualcomm.com> (sfid-20170113_092127_609837_3E05FDDB)
Date: Fri, 13 Jan 2017 09:20:27 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> 
> 11ad device supports 48 bit addresses, reflect that
> by setting the dma mask accordingly.
> 
> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Dropped per Maya's request

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9513167/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
