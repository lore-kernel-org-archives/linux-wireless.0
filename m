Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36340 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbcAAXOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 18:14:48 -0500
Received: by mail-lf0-f54.google.com with SMTP id z124so246904788lfa.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jan 2016 15:14:48 -0800 (PST)
Subject: Re: [PATCH] net-libertas: Better exception handling in
 if_spi_host_to_card_worker()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686F0B2.5000000@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56870866.7020000@cogentembedded.com> (sfid-20160102_001508_191482_CAA8A880)
Date: Sat, 2 Jan 2016 02:14:46 +0300
MIME-Version: 1.0
In-Reply-To: <5686F0B2.5000000@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On 1/2/2016 12:33 AM, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 1 Jan 2016 22:27:20 +0100
>
> This issue was detected by using the Coccinelle software.
>
> Move the jump label directly before the desired log statement
> so that the variable "err" will not be checked once more
> after it was determined that a function call failed.
> Use the identifier "report_failure" instead of the label "err".

    Why? The code was smart enough and you're making it uglier that it needs 
to be.

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

MBR, Sergei

