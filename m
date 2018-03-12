Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38178 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeCLMoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 08:44:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id z9so15784119wmb.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2018 05:44:06 -0700 (PDT)
Subject: Re: [2/3] mwifiex: support sysfs initiated device coredump
To: Kalle Valo <kvalo@codeaurora.org>
References: <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
 <20180312094115.2E1C1606DB@smtp.codeaurora.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA67616.2000602@broadcom.com> (sfid-20180312_134421_106115_F6643297)
Date: Mon, 12 Mar 2018 13:44:06 +0100
MIME-Version: 1.0
In-Reply-To: <20180312094115.2E1C1606DB@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/12/2018 10:41 AM, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>
>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>> it is possible to initiate a device coredump from user-space. This
>> patch adds support for it adding the .coredump() driver callback.
>> As there is no longer a need to initiate it through debugfs remove
>> that code.
>>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
> Based on the discussion I assume this is ok to take to w-d-next. If that's not
> the case, please let me know ASAP.

It is up to the mwifiex maintainers to decide, I guess. The ABI 
documentation need to be revised and change the callback to void return 
type. I am not sure what the best approach is. 1) apply this and fix 
return type later, or 2) fix return type and resubmit this. What is your 
opinion?

Regards,
Arend
