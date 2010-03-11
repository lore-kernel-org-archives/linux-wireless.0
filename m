Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:45866 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0CKGFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 01:05:12 -0500
Received: by pzk32 with SMTP id 32so469983pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 22:05:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Mar 2010 22:04:51 -0800
Message-ID: <43e72e891003102204u17bc2916xbc4cc17af30d3360@mail.gmail.com>
Subject: Re: [PATCH 00/14] ath9k: initial work for hardware layering
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 5:28 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This is my first series which starts the work of adding a new layering for
> abstraction for hardware access. The goal is to enable the AR9003 hardware
> family to be supported by sharing as much code as is possible. To do that
> we abstract away all calls which do reads/writes.
>
> I'll next address more abstraction on ANI/mac/hw calls. The final
> move will be to rename reg.h to ar92002_reg.h and ensure no common
> hardware code uses it. We then should be able to start adding
> ar9003 hardware family code support and the rest of the core
> driver changes required.
>
> It should be technically possible to even share some stuff like ANI
> with ath5k but that's my own priority right now but I welcome others
> to review that. If its not clear how that's possible now perhaps
> it will be on my next series where I'll dabble a bit more on ANI.
>
> I've rebased this on top of the ath9k_htc patches, and tested this
> with AR9280 (ath9k) and AR9271 (ath9k_htc).

John, disregard this patch series, we will resubmit ath9k_htc stuff
and I will have to rebase laster on top of that.

  Luis
