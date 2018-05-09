Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:38027 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964827AbeEIS5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 14:57:36 -0400
Subject: Re: [PATCH] ssb: Fix regression caused by disabling PCI cores on
 non-MIPS architecture
To: Jeff Johnson <jjohnson@codeaurora.org>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        linux-wireless-owner@vger.kernel.org
References: <20180509164220.22653-1-Larry.Finger@lwfinger.net>
 <d31853aa21d1c610d09bce696423cfe2@codeaurora.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5f7abc22-f3e5-fce3-690b-17e40ef73c8a@lwfinger.net> (sfid-20180509_205745_508412_5143274F)
Date: Wed, 9 May 2018 13:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <d31853aa21d1c610d09bce696423cfe2@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2018 11:57 AM, Jeff Johnson wrote:
> On 2018-05-09 09:42, Larry Finger wrote:
>> Some MPIS-based SoCs use chips driven by b43 for wireless capability.
> typo: MPIS=>MIPS

Jeff,

Thanks. I will fix this with V2.

Larry
