Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:44354 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZHSSny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 14:43:54 -0400
Received: by yxe5 with SMTP id 5so5655342yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 11:43:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8f3763990908191119l37c7dff3y8884b1228059cb22@mail.gmail.com>
References: <8f3763990908191119l37c7dff3y8884b1228059cb22@mail.gmail.com>
Date: Wed, 19 Aug 2009 14:43:55 -0400
Message-ID: <b6c5339f0908191143y6940d664td6cb39b2021e125b@mail.gmail.com>
Subject: Re: bug? sme.c:610 __cfg80211_disconnected
From: Bob Copeland <me@bobcopeland.com>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 2:19 PM, ASIC Felix<ic.felix@gmail.com> wrote:
> Hi,
>
> update:
>   occurs during rekeying/reauth on wpa2 office network
>   still present in master-2009-08-19
>
> Aug 19 11:04:02 darkslate klogd: WARNING: at net/wireless/sme.c:613
> __cfg80211_disconnected+0x1bc/0x210 [cfg80211]()

Please post the entire warning's stack trace inline (i.e.
not as an attachment).

I looked at your previous email in which you had attached
the log, and it looked like ath9k was the wireless driver,
though it could be a bug in {mac,cfg}80211 as well.  It's
impossible to tell just from this one line though.

-- 
Bob Copeland %% www.bobcopeland.com
