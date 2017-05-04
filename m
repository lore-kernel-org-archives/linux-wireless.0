Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43899 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdEDNAv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 09:00:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: append the wmi_op_version to testmode get_version cmd
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1493155156-22697-1-git-send-email-ryanhsu@qti.qualcomm.com>
References: <1493155156-22697-1-git-send-email-ryanhsu@qti.qualcomm.com>
To: <ryanhsu@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qti.qualcomm.com>
Message-ID: <f2affc9fdafb443b962a418be6d2470b@eusanexr01a.eu.qualcomm.com> (sfid-20170504_150128_809288_6FD04E9A)
Date: Thu, 4 May 2017 06:00:47 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@qti.qualcomm.com wrote:
> From: Ryan Hsu <ryanhsu@qti.qualcomm.com>
> 
> QCA9xxx and QCA61x4/QCA93xx are using different wmi operation, in order
> for userspace to differentiate it, appends the wmi_op_version information
> alone with the get_version command.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

4dcb78085d56 ath10k: append the wmi_op_version to testmode get_version cmd

-- 
https://patchwork.kernel.org/patch/9699775/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
