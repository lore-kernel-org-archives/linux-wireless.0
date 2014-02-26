Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:43429 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaBZMJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 07:09:38 -0500
Received: by mail-ee0-f43.google.com with SMTP id e53so294239eek.30
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 04:09:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393414465-3666-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1393414465-3666-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Feb 2014 13:09:36 +0100
Message-ID: <CA+BoTQkKnDYj2Z6GiChZt7OBmbsxVfgJJEzeKgFw-Rm2=ragwg@mail.gmail.com> (sfid-20140226_130944_274792_763713CF)
Subject: Re: [PATCH v2 0/8] ath10k: performance improvements
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 February 2014 12:34, Michal Kazior <michal.kazior@tieto.com> wrote:
> Hi,
>
> These patches aim at reducing host CPU load and
> thus improve performance on low-end systems.
>
> In my setup I get a relative improvement of
> 100mbps for both UDP Tx and Rx.
>
>                Tx ----->
> laptop:eth---eth:AP135:ath10k---ath10k:laptop
>                <----- Rx
>
>
> v2:
>  * improve comments/commit messages
>  * fix 1 unbalanced locking
>  * fix var naming (s/err/ret)
>  * remove code that didn't belong here
>  * split batch tx/rx into 2 patches
>    (+ath10k: reduce htt tx/rx spinlock overhead)

My bloody mail server said it's too busy and dropped some of the
patches.. I'll try to re-send it as v3 later.


Michał
