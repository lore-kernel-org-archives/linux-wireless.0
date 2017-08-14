Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33509 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbdHNUu7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 16:50:59 -0400
Received: by mail-oi0-f66.google.com with SMTP id e124so10383837oig.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2017 13:50:59 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] rtlwifi: use debugfs to debug.
To: Barry Day <briselec@gmail.com>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
References: <20170810164744.9336-1-Larry.Finger@lwfinger.net>
 <20170810164744.9336-2-Larry.Finger@lwfinger.net>
 <20170814044901.GA12440@testbox>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f2c4db8d-face-6d5a-6100-c228e84c9142@lwfinger.net> (sfid-20170814_225107_461263_B7D3B217)
Date: Mon, 14 Aug 2017 15:50:53 -0500
MIME-Version: 1.0
In-Reply-To: <20170814044901.GA12440@testbox>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2017 11:49 PM, Barry Day wrote:
> On Thu, Aug 10, 2017 at 11:47:43AM -0500, Larry Finger wrote:
>> +struct rtl_debgufs_priv {
> 
> spelling mistake ?
> 

Yes, but a philosophical question remains: I understand that a comment can 
contain a typo. but is it really possible for the name of a struct? As long as 
the coder is consistent, is it wrong?

That said, I changed it to rtl_debugfs_priv.

Larry
