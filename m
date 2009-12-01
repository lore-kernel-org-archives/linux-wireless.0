Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:57868 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZLAPkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 10:40:37 -0500
Received: by iwn1 with SMTP id 1so3142304iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 07:40:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091201084715.7996.37035.stgit@tikku>
References: <20091201084715.7996.37035.stgit@tikku>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Dec 2009 07:40:19 -0800
Message-ID: <43e72e890912010740v445f9e7dq3452baf1bc4e935f@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: indent regulatory messages with spaces
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 1, 2009 at 12:47 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
>
> The regulatory messages in syslog look weird:
>
> kernel: cfg80211: Regulatory domain: US
> kernel: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
>
> Indent them with four spaces instead of the tab character to get prettier
> output.
>

Acked: Luis R. Rodriguez <lrodriguez@atheros.com>

> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Thanks been meaning to get to that, glad you scratched the itch.

  Luis
