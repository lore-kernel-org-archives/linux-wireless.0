Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46993 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaAPJci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 04:32:38 -0500
Received: by mail-bk0-f53.google.com with SMTP id na10so1080208bkb.40
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 01:32:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <877ga0uvip.fsf@kamboji.qca.qualcomm.com>
References: <1389863904-7159-1-git-send-email-yeohchunyeow@gmail.com>
	<877ga0uvip.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 16 Jan 2014 17:32:37 +0800
Message-ID: <CAEFj9864XNeSKQRfVuo+KAKr76DVFM574arTCLLCTN+otzktAQ@mail.gmail.com> (sfid-20140116_103246_276464_D45F02EB)
Subject: Re: [PATCH] ath10k: set the AP keepalive timer
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Heh, bad timing. Yesterday I implemented STA quick kickout and in that
> patch I set the same parameters as you did. I just used longer values to
> avoid inactivity timeouts triggering in the firmware. We have the same
> functionality in hostapd, so there's no need to use the one in firmware.
>
> I'll send my patch after lunch, please take a look at that and see if
> it's ok.
Ok, no problem.

I am annoying that immediately getting continuous
WMI_PEER_STA_KICKOUT_EVENTID message even though the STA is active
when tested with firmware 10.1.467-1.

----
Chun-Yeow
