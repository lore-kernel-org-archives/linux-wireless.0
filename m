Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdALU1M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 15:27:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 12 Jan 2017 22:27:11 +0200
From: merez@codeaurora.org
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Hamad Kadmany <QCA_hkadmany@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2 12/13] wil6210: set dma mask to reflect device
 capability
In-Reply-To: <1484226365-10433-13-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1484226365-10433-13-git-send-email-qca_merez@qca.qualcomm.com>
Message-ID: <fc9a14ebf619db9817d262aa5381a69e@codeaurora.org> (sfid-20170112_212716_662238_ED569B54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-12 15:06, Maya Erez wrote:
> From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> 
> 11ad device supports 48 bit addresses, reflect that
> by setting the dma mask accordingly.
> 
> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---

Kalle, we found an issue caused by this patch. Please don't apply it.
-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
