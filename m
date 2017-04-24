Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1168977AbdDXL0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 07:26:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 00/14] rtlwifi: btcoex: Second set of changes for rtl8821ae 2ant
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
        <87zifb65eh.fsf@codeaurora.org>
        <5df931fe-cbb8-a0f7-ec0f-a62180ca760d@lwfinger.net>
        <87lgqu45d0.fsf@kamboji.qca.qualcomm.com>
        <d4c9dbc7-306a-df9b-cede-e0be462790e4@lwfinger.net>
Date: Mon, 24 Apr 2017 14:26:05 +0300
In-Reply-To: <d4c9dbc7-306a-df9b-cede-e0be462790e4@lwfinger.net> (Larry
        Finger's message of "Fri, 21 Apr 2017 09:40:32 -0500")
Message-ID: <87h91e2gj6.fsf@kamboji.qca.qualcomm.com> (sfid-20170424_132624_823009_7EE43EAB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 04/21/2017 01:55 AM, Kalle Valo wrote:
>> But what should I do with this one:
>>
>> rtlwifi: rtl8821ae: setup 8812ae RFE according to device type
>> https://patchwork.kernel.org/patch/9683395/
>
> Please apply that one. It should not conflict due to dropping the others.

Ok, I'll take that one.

-- 
Kalle Valo
