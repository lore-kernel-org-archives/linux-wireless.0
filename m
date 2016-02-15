Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33283 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbcBOAec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2016 19:34:32 -0500
Received: by mail-io0-f171.google.com with SMTP id z135so73762558iof.0
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2016 16:34:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455487069-2721-1-git-send-email-festevam@gmail.com>
References: <1455487069-2721-1-git-send-email-festevam@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 15 Feb 2016 11:34:11 +1100
Message-ID: <CAGRGNgV7tKJe-PkjH56LJ41-pbRVGH7PAxqMhr1nPtx=0qUhHA@mail.gmail.com> (sfid-20160215_013440_936746_F8D3BE09)
Subject: Re: [PATCH] brcmfmac: of: Include "of.h" header file
To: Fabio Estevam <festevam@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Mon, Feb 15, 2016 at 8:57 AM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
>
> Include "of.h" header file to fix the following sparse warning:
>
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c:27:6: warning: symbol 'brcmf_of_probe' was not declared. Should it be static?
>
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

Looks correct to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
