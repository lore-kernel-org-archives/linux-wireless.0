Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33764 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbcDPIPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 04:15:25 -0400
Received: by mail-io0-f173.google.com with SMTP id o126so155386638iod.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 Apr 2016 01:15:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460367328-12082-4-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
	<1460367328-12082-4-git-send-email-arend@broadcom.com>
Date: Sat, 16 Apr 2016 10:15:24 +0200
Message-ID: <CACna6ryO6HZ8jiy_K1P=v+ZNRb=yzb=mOAreaWYoiCjZBfb9Vw@mail.gmail.com> (sfid-20160416_101534_469709_783B3989)
Subject: Re: [PATCH 3/8] brcmfmac: insert default boardrev in nvram data if missing
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2016 at 11:35, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <hante.meuleman@broadcom.com>
>
> Some nvram files/stores come without the boardrev information,
> but firmware requires this to be set. When not found in nvram then
> add a default boardrev string to the nvram data.
>
> Reported-by: Rafal Milecki <zajec5@gmail.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <franky.lin@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

I needed to wait for a weekend to give it a try. It fixed my problem,
nice work, thanks!
Tested-by: Rafal Milecki <zajec5@gmail.com>
