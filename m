Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34331 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755119AbcK2HIL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 02:08:11 -0500
Received: by mail-oi0-f46.google.com with SMTP id y198so180295607oia.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 23:08:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479896731-5091-4-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com> <1479896731-5091-4-git-send-email-arend.vanspriel@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 29 Nov 2016 08:08:10 +0100
Message-ID: <CACna6rwSDT1UeuexMpNhVMxKHWpZGdzDg7C1b5wVOhXzO3o=MA@mail.gmail.com> (sfid-20161129_080814_911793_E1764CEC)
Subject: Re: [PATCH 03/12] brcmfmac: move pno helper functions in separate
 source file
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 November 2016 at 11:25, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> Introducing new source file for pno related functionality. Moving
> existing pno functions.

Let me ask one basic question as I'm curious: what that PNO stands
for? I couldn't find it explained in the code.
