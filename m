Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44570 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752570AbdEIHxt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 03:53:49 -0400
Message-ID: <1494316415.2410.0.camel@sipsolutions.net> (sfid-20170509_095436_216312_C9D072FC)
Subject: Re: [PATCH] wil6210: Replace five seq_puts() calls by seq_putc()
From: Johannes Berg <johannes@sipsolutions.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        wil6210@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Tue, 09 May 2017 09:53:35 +0200
In-Reply-To: <64747f85-e373-a0ff-b6dc-70cdfe35f71a@users.sourceforge.net> (sfid-20170509_095233_422214_ACF722B1)
References: <64747f85-e373-a0ff-b6dc-70cdfe35f71a@users.sourceforge.net>
         (sfid-20170509_095233_422214_ACF722B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-09 at 09:50 +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 8 May 2017 22:22:04 +0200
> 
> Five single characters (line breaks) should be put into a sequence.
> Thus use the corresponding function "seq_putc".

Please stop, this isn't really an issue worth worrying about.

johannes
