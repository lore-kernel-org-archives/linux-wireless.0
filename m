Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:49224 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895Ab2EVOZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 10:25:58 -0400
Received: by lagy4 with SMTP id y4so4599868lag.29
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 07:25:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871umc8nzy.fsf@purkki.adurom.net>
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
	<871umc8nzy.fsf@purkki.adurom.net>
Date: Tue, 22 May 2012 17:25:55 +0300
Message-ID: <CAK80WHbaw2O7AEVpoEpD4iw6jqoJJG=umCqJz8aux3JELLOc_w@mail.gmail.com> (sfid-20120522_162602_891838_03089BF5)
Subject: Re: [PATCH] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 22, 2012 at 2:16 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Please document that the callback is optional and it can sleep.
>

Will send v2 with updated documentation.

Thanks for the review.

-- 
Victor.
