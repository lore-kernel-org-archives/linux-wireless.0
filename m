Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35620 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdBTGfP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 01:35:15 -0500
Received: by mail-lf0-f46.google.com with SMTP id z127so44644466lfa.2
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 22:35:14 -0800 (PST)
Subject: Re: [PATCH v2] rtl8187: Enable monitor mode to fix multicast
 reception
To: Nils Holland <nholland@tisys.org>, linux-wireless@vger.kernel.org
References: <20170219235919.GA15763@tisys.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <6dafa711-2118-ed6d-4b55-2640a3b852e5@gmail.com> (sfid-20170220_073519_014589_6480B8FC)
Date: Mon, 20 Feb 2017 07:35:12 +0100
MIME-Version: 1.0
In-Reply-To: <20170219235919.GA15763@tisys.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2017 12:59 AM, Nils Holland wrote:
> The rtl8187 cards don't seem to receive multicast frames, which,
> among other things, makes them fail to receive RAs in IPv6 networks.
> The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
> have the desired effect.

AFAIU you have RTL8187B chipset card only, but above message describes this as
generic issue (including RTL8187 and RTL8187L).

Larry: were you able to reproduce this problem using RTL8187L? Is this
workaround needed for that chipset as well? I couldn't find clear statement.
