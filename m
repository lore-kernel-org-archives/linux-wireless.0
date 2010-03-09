Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64627 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab0CIR7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 12:59:05 -0500
Received: by pvb32 with SMTP id 32so1882176pvb.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 09:59:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268137502-25339-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268137502-25339-1-git-send-email-juuso.oikarinen@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Mar 2010 09:58:43 -0800
Message-ID: <43e72e891003090958k4413b171i911b163b8ee675ba@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Fix (dynamic) power save entry
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 9, 2010 at 4:25 AM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> Currently hardware with !IEEE80211_HW_PS_NULLFUNC_STACK and
> IEEE80211_HW_REPORTS_TX_ACK_STATUS will never enter PSM due to the
> conditions in the power save entry functions.
>
> Fix those conditions.

Is this a stable fix, for 33?

  Luis
