Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752040AbdGDLBG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 07:01:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stefan Assmann <sassmann@kpanic.de>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8723bs: fix build when DEBUG_RTL871X is defined
References: <20170703122733.28512-1-sassmann@kpanic.de>
Date: Tue, 04 Jul 2017 14:01:00 +0300
In-Reply-To: <20170703122733.28512-1-sassmann@kpanic.de> (Stefan Assmann's
        message of "Mon, 3 Jul 2017 14:27:33 +0200")
Message-ID: <874lus31qr.fsf@purkki.adurom.net> (sfid-20170704_130110_054838_E70D221D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Assmann <sassmann@kpanic.de> writes:

> Defining DEBUG_RTL871X in rtw_debug.h causes the following compile error:
>   CC [M]  drivers/staging/rtl8723bs/core/rtw_mlme.o
> In file included from drivers/staging/rtl8723bs/core/rtw_mlme.c:18:0:
> drivers/staging/rtl8723bs/core/rtw_mlme.c: In function =E2=80=98rtw_restr=
uct_sec_ie=E2=80=99:
> drivers/staging/rtl8723bs/core/rtw_mlme.c:2502:19: error: =E2=80=98ndisse=
curitytype=E2=80=99 undeclared (first use in thisfunction)
>
> Remove the no longer existing parameter.
>
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>

Please use prefix "staging:" for staging patches.

--=20
Kalle Valo
