Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32813 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765105AbcLWRr0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Dec 2016 12:47:26 -0500
Received: by mail-wm0-f68.google.com with SMTP id u144so42716592wmu.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2016 09:47:25 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
Date: Fri, 23 Dec 2016 18:47:22 +0100
Message-ID: <1796267.ZQn77y5fxL@debian64> (sfid-20161223_184825_069858_8DEC9A11)
In-Reply-To: <1482505955-9310-1-git-send-email-igor.mitsyanko.os@quantenna.com>
References: <87d1hmnrqj.fsf@purkki.adurom.net> <1482505955-9310-1-git-send-email-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, December 23, 2016 6:12:35 PM CET igor.mitsyanko.os@quantenna.com wrote:
> From: Igor Mitsyanko <imitsyanko@quantenna.com>
> 
> QSR10G is Quantenna's 8x8, 160M, 11ac WiFi card.
> 
> Signed-off-by: Kamlesh Rath <krath@quantenna.com>
> Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
> Signed-off-by: Avinash Patil <avinashp@quantenna.com>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> ---
> This is an RFC patch that we sent to linux-wireless mailing list a while ago,
> and it spawned a discussion regarding whether GPL sources has to be submitted
> together with this firmware. We would like to clarify with linux-firmware maintainers
> to understnad what should be our actions to allow this to be accepted.
> - firmware contains GPL components;
> - LICENCE file states that sources for GPL components will be provided on request
> to oslegal@quantenna.com
> 
> There was an opinion that it is not enough: precedent case like this with carl9170
> firmware was resolved by submitting GPL sources into linux-firmware repository
> itself.
The ar9170-usb firmware was released as GPL v2.0 from the get-go.
<http://git.sipsolutions.net/ar9170-fw.git/commit/GPL?id=2e3574ce10c74a82047a06b046855de14d969948>

And this was never a problem. What is THE PROBLEM though:
"if all the patches from ar9170fw to carl9170fw and beyond (i.e new versions)
have to be added to linux-firmware.git." Or not.

That's why there was never a update to the carl9170fw.
So be prepared for this scenario too.

> Does the same applies to qsr10g firmware?
>
> The SDK that we use to build it is quite heavy (> 100MB, but with toolchain). 
> Maybe we can take another approach to place SDK separately on Quantenna website
> (as a compressed archive), and add a link in linux-firmware?
Yes, I would like to know this as well.

Regards,
Christian
