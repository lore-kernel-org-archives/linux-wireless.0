Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35182 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbLYKPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2015 05:15:55 -0500
Received: by mail-wm0-f42.google.com with SMTP id l126so202048180wml.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Dec 2015 02:15:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <567D1268.70709@gmail.com>
References: <CAOQ7t2bEs2UhxfWUCs7TBwidw2JKCKLmeUzcYjng4f5p4Wr-Mw@mail.gmail.com>
	<567D1268.70709@gmail.com>
Date: Fri, 25 Dec 2015 11:15:54 +0100
Message-ID: <CAOQ7t2aJr6Ub+7t1B7XfJvJb_p2AMV+77MsiozZz73uQaxOVnw@mail.gmail.com> (sfid-20151225_111630_321542_E085B782)
Subject: Re: [BISECTED] brcmfmac issue since 4.3.0-rc3
From: Carlo Caione <carlo@caione.org>
To: Arend van Spriel <aspriel@gmail.com>
Cc: Carlo Caione <carlo@caione.org>, meuleman@broadcom.com,
	arend@broadcom.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 25, 2015 at 10:54 AM, Arend van Spriel <aspriel@gmail.com> wrote:
> Hi Carlo,
>
> This smells like a firmware crash. Upon the brcmf_bus_start failure we
> bail out on the probe. I suspect in the error path there is an issue
> introduced (or exposed) by the mentioned patch. Did not look further
> into it as the family is giving me the angry look during the holidays ;-)

Hi Arend,
Thank you for the quick reply, this can definitely wait ;-)
Happy holidays and happy new year!

-- 
Carlo Caione
