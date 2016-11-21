Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33913 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753586AbcKURYO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 12:24:14 -0500
Received: by mail-pg0-f42.google.com with SMTP id x23so129655095pgx.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 09:24:14 -0800 (PST)
Date: Mon, 21 Nov 2016 09:24:10 -0800
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Shengzhen Li <szli@marvell.com>
Subject: Re: [PATCH v3 01/11] mwifiex: check tx_hw_pending before downloading
 sleep confirm
Message-ID: <20161121172409.GA144604@google.com> (sfid-20161121_182417_975187_36EB26F7)
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
 <20161114194049.GA131593@google.com>
 <877f82mg7s.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877f82mg7s.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2016 at 02:41:11PM +0200, Kalle Valo wrote:
> Patchwork link for the same:
> 
> https://patchwork.kernel.org/project/linux-wireless/list/?state=2&q=mwifiex
> 
> Does that look ok?

FWIW, your merges (since you made the above comments) look sane to me.
Thanks!

Brian
