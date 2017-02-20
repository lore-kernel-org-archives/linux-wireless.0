Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34849 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753434AbdBTQSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 11:18:21 -0500
Received: by mail-oi0-f47.google.com with SMTP id 62so40841441oih.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 08:18:20 -0800 (PST)
Subject: Re: [PATCH v2] rtl8187: Enable monitor mode to fix multicast
 reception
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Nils Holland <nholland@tisys.org>,
        linux-wireless@vger.kernel.org
References: <20170219235919.GA15763@tisys.org>
 <6dafa711-2118-ed6d-4b55-2640a3b852e5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <33f6e879-541f-ef45-f533-98b44e6aa2a9@lwfinger.net> (sfid-20170220_171841_732321_83E87FF0)
Date: Mon, 20 Feb 2017 10:18:18 -0600
MIME-Version: 1.0
In-Reply-To: <6dafa711-2118-ed6d-4b55-2640a3b852e5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2017 12:35 AM, Rafał Miłecki wrote:
> On 02/20/2017 12:59 AM, Nils Holland wrote:
>> The rtl8187 cards don't seem to receive multicast frames, which,
>> among other things, makes them fail to receive RAs in IPv6 networks.
>> The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
>> have the desired effect.
>
> AFAIU you have RTL8187B chipset card only, but above message describes this as
> generic issue (including RTL8187 and RTL8187L).
>
> Larry: were you able to reproduce this problem using RTL8187L? Is this
> workaround needed for that chipset as well? I couldn't find clear statement.

Yes, the RTL8187L has the same problem as the RTL8187B. The fix is needed for both.

Larry
