Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:51339 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3GJKwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 06:52:03 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so2750847bkc.21
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jul 2013 03:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373394424-23298-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373394424-23298-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1373394424-23298-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Date: Wed, 10 Jul 2013 12:52:00 +0200
Message-ID: <CA+BoTQniF+b0JAjiKyRApttz8Or+urYB+XCxsNFA4y87Cbry-w@mail.gmail.com> (sfid-20130710_125207_510497_8AFEDF05)
Subject: Re: [PATCHv4 4/5] mac80211: add channel switch command and beacon callbacks
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2013 20:27, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> (...)
> +       /* don't handle if chanctx is used */
> +       if (local->use_chanctx)
> +               return -EINVAL;
> (...)

This check doesn't seem to be necessary anymore (since you verify if
the number of channel contexts is 1), or is it?


Pozdrawiam / Best regards,
Michał Kazior.
