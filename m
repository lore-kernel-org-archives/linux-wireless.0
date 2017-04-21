Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34299 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161769AbdDUPw0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 11:52:26 -0400
Received: by mail-oi0-f68.google.com with SMTP id y11so19387980oie.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Apr 2017 08:52:26 -0700 (PDT)
Subject: Re: [PATCH 00/14] rtlwifi: btcoex: Second set of changes for
 rtl8821ae 2ant
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
 <87zifb65eh.fsf@codeaurora.org>
 <5df931fe-cbb8-a0f7-ec0f-a62180ca760d@lwfinger.net>
 <87lgqu45d0.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d4c9dbc7-306a-df9b-cede-e0be462790e4@lwfinger.net> (sfid-20170421_175247_452144_E1CE8F95)
Date: Fri, 21 Apr 2017 09:40:32 -0500
MIME-Version: 1.0
In-Reply-To: <87lgqu45d0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/21/2017 01:55 AM, Kalle Valo wrote:
> But what should I do with this one:
>
> rtlwifi: rtl8821ae: setup 8812ae RFE according to device type
> https://patchwork.kernel.org/patch/9683395/

Please apply that one. It should not conflict due to dropping the others.

Thanks,

Larry
