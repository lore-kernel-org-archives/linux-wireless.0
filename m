Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36159 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbcHTT0o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Aug 2016 15:26:44 -0400
Received: by mail-wm0-f43.google.com with SMTP id q128so72466908wma.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Aug 2016 12:26:44 -0700 (PDT)
Subject: Re: [PATCH 0/3] hostap: Fine-tuning for a few functions
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <f0cd7a82-e603-6a91-0afd-33bbd1658cab@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3b3c91ad-3225-3483-bb58-fdee33bf2290@broadcom.com> (sfid-20160820_212709_724340_46B0DBF1)
Date: Sat, 20 Aug 2016 21:26:42 +0200
MIME-Version: 1.0
In-Reply-To: <f0cd7a82-e603-6a91-0afd-33bbd1658cab@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-08-16 18:43, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 20 Aug 2016 18:35:43 +0200
> 
> A few update suggestions were taken into account
> from static source code analysis.

Is it worth touching this old stuff especially when you are not making
any functional changes.

Regards,
Arend

> Markus Elfring (3):
>   Use memdup_user()
>   Delete an unnecessary jump label
>   Delete unnecessary variable initialisations
> 
>  .../net/wireless/intersil/hostap/hostap_ioctl.c    | 36 ++++++++--------------
>  1 file changed, 12 insertions(+), 24 deletions(-)
> 
