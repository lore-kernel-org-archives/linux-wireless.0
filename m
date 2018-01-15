Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966992AbeAONSw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 08:18:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 15 Jan 2018 15:18:51 +0200
From: merez@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        Lazar Alexei <QCA_ailizaro@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [v2,6/9] wil6210: add support for headroom configuration
In-Reply-To: <20180109080707.B05B66081B@smtp.codeaurora.org>
References: <1513270393-919-7-git-send-email-qca_merez@qca.qualcomm.com>
 <20180109080707.B05B66081B@smtp.codeaurora.org>
Message-ID: <1384d3ee94eb48f29e85161d9a8fa136@codeaurora.org> (sfid-20180115_141913_057111_57F09311)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-09 10:07, Kalle Valo wrote:
> Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> 
>> Add module parameter for configuring the headroom size
>> in the skb allocation.
>> 
>> Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Why?

Some platforms have specific requirements on packet alignment.
I will upload an update of the commit text in the next set of 11ad 
patches.

> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why
> 
> And I'm a bit skeptic about this, controlling headroom via a module 
> parameter
> is not really making any sense to me.
-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
