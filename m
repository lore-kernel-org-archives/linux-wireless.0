Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51880 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1BXM26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 07:28:58 -0500
Received: by bwz15 with SMTP id 15so955069bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 04:28:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4d653260.FQ995fSRTBGWdIFh%Larry.Finger@lwfinger.net>
References: <4d653260.FQ995fSRTBGWdIFh%Larry.Finger@lwfinger.net>
Date: Thu, 24 Feb 2011 12:28:57 +0000
Message-ID: <AANLkTi=kko7Uc3oTsWOQzgKi0wSiYdyoWJ5ivyFtuRVP@mail.gmail.com>
Subject: Re: [PATCH V2 1/5] rtlwifi: Fix build when RTL8192CU is selected, but
 RTL8192CE is not
From: Otavio Salvador <otavio@ossystems.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, sfr@canb.auug.org.au,
	w@1wt.eu, george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 23, 2011 at 16:14, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: Willy Tarreau <w@1wt.eu>
> Date: Sun, 20 Feb 2011 11:35:26 +0100
> Subject: rtlwifi: Fix build when RTL8192CU is selected, but RTL8192CE is not
>
> The wireless Makefile does not build rtlwifi for rtl8192cu unless
> rtl8192ce is selected.
>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Tested-by: Otavio Salvador <otavio@ossystems.com.br>

-- 
Otavio Salvador                             O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854              http://projetos.ossystems.com.br
