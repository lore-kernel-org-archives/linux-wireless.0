Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40045 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1ISToY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:44:24 -0400
Received: by wwf22 with SMTP id 22so8473498wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 12:44:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316460850-16443-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1316460850-16443-1-git-send-email-Larry.Finger@lwfinger.net>
	<1316460850-16443-2-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 19 Sep 2011 21:44:22 +0200
Message-ID: <CACna6ryk5em_JOBLO+oWiXkb8tO6=179sPP54=RJdsN=X=7JWw@mail.gmail.com> (sfid-20110919_214428_934322_944D1D29)
Subject: Re: [PATCH 1/4] rtlwifi: rtl8192ce: Change modinfo messages
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/19 Larry Finger <Larry.Finger@lwfinger.net>:
> The various modparam messages are difficult to understand.

I'm not native English speaker, or language expert, so it's more like
a question than real opinion.


> +       if (!rtlpriv->psc.inactiveps)
> +               pr_info("rtl8192ce: Power Save off (module option)\n");
> +       if (!rtlpriv->psc.fwctrl_lps)
> +               pr_info("rtl8192ce: FW Power Save off (module option)\n");

Wouldn't something like "Power Save turner off (by module option)" sound better?

-- 
Rafał
