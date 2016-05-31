Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35738 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbcEaNB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 09:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <20160531055858.GA32239@google.com>
References: <20160531055858.GA32239@google.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 31 May 2016 23:01:06 +1000
Message-ID: <CAGRGNgWXq076qnu9ucFR9d60i2BzMcREd8AeTrDMmC33kEeQ=A@mail.gmail.com> (sfid-20160531_150151_072718_1D7832A0)
Subject: Re: [PATCH] net/wireless: Fix 'multiple blank lines' check
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Tue, May 31, 2016 at 3:58 PM, Kirtika Ruchandani
<kirtika.ruchandani@gmail.com> wrote:
> This patch fixes the checkpatch.pl check "Please don't use multiple
> blank lines" for all files in net/wireless, except nl80211.c which
> is covered in a separated patch.
>
> Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  net/wireless/ap.c          | 1 -
>  net/wireless/chan.c        | 3 ---
>  net/wireless/core.h        | 2 --
>  net/wireless/ibss.c        | 1 -
>  net/wireless/mlme.c        | 2 --
>  net/wireless/radiotap.c    | 2 --
>  net/wireless/rdev-ops.h    | 2 --
>  net/wireless/reg.c         | 3 ---
>  net/wireless/scan.c        | 1 -
>  net/wireless/sme.c         | 1 -
>  net/wireless/util.c        | 2 --
>  net/wireless/wext-compat.c | 3 ---
>  net/wireless/wext-compat.h | 2 --
>  net/wireless/wext-core.c   | 6 ------
>  net/wireless/wext-proc.c   | 1 -
>  net/wireless/wext-sme.c    | 1 -
>  16 files changed, 33 deletions(-)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
