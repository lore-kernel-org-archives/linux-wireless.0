Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34550 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbcDKLUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 07:20:25 -0400
Received: by mail-io0-f174.google.com with SMTP id 2so204159418ioy.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 04:20:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460367328-12082-1-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
Date: Mon, 11 Apr 2016 13:20:24 +0200
Message-ID: <CACna6rwCe6yfzcxdezKhPJwJ4cnWY4DEE04W81K=PrVD1pZVoA@mail.gmail.com> (sfid-20160411_132029_800426_9EACF898)
Subject: Re: [PATCH 0/8] brcmfmac: event handling and other fixes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2016 at 11:35, Arend van Spriel <arend@broadcom.com> wrote:
> This series provides the following:
>
> * avoid unexpected firmware events.
> * allow passing events explicitly for PCIe and SDIO devices.
> * fix issue with boardrev entry in nvram.
> * fix for wowl.
> * fix possible null pointer access upon aborting p2p scan.
>
> The series is intended for v4.7 kernel and applies to the master
> branch of the wireless-drivers-next repository.

Hey Arend,

Unfortunately I'm finding all your recent messages in spam :( It seems
GMail doesn't like something about the Broadcom server:
"Why is this message in Spam? It has a from address in broadcom.com
but has failed broadcom.com's required tests for authentication. Learn
more"
Quoted "Learn more" text links to the:
https://support.google.com/mail/answer/1366858?hl=en-GB&expand=5

Do you think you can point it to sb at Broadcom?
