Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:34769 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdGEMou (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 08:44:50 -0400
Received: by mail-ua0-f194.google.com with SMTP id l38so17257164uaf.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jul 2017 05:44:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7bb1d52c-9a9f-ea3f-92dc-faad1fde97f5@lwfinger.net>
References: <20170704072147.GA5678@symbol-HP-ZBook-15> <7bb1d52c-9a9f-ea3f-92dc-faad1fde97f5@lwfinger.net>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 5 Jul 2017 18:14:48 +0530
Message-ID: <CAFqt6zYXtWOx8ock-dJ40B88rohtW02MAikqYe0EGu_cromQ+g@mail.gmail.com> (sfid-20170705_144454_203110_C12DB40A)
Subject: Re: [PATCH] rtlwifi: Handle memory free
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 5, 2017 at 1:53 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/04/2017 02:21 AM, Souptick Joarder wrote:
>>
>> This patch will fix memory leak when firmware load fails
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
>
> The patch title needs to be improved. "Handle memory free" tells us nothing

Ok, I will change the patch title and send a new patch.
>
> NACK.
>
> Larry
