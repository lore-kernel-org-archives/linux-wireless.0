Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46753 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaEMMmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 08:42:16 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so309483wgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 05:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399977126-8343-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399977126-8343-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 13 May 2014 14:42:14 +0200
Message-ID: <CACKGw+Hd2=26Dv4uc9Q5LoDnQmmfMqYGEM0V6syeEAXqRhTpFw@mail.gmail.com> (sfid-20140513_144220_395872_C924A269)
Subject: Re: [PATCH 1/2] ath: add DFS FCC pattern detector
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 May 2014 12:32, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> Add initial values for DFS FCC pattern detector.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  drivers/net/wireless/ath/dfs_pattern_detector.c |   25 ++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)

Both (FCC and JP) tested fine with ath10k on DFS VeriWave setup, you may add:
Tested-by: Bartosz Markowski <bartosz.markowski@tieto.com>

-Bartosz
