Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38440 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbdG1O2U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:28:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rsi: use macro for allocating USB buffer
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1499783273-15428-1-git-send-email-amitkarwar@gmail.com>
References: <1499783273-15428-1-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170728142819.99A416022C@smtp.codeaurora.org> (sfid-20170728_162826_170959_908DBF8D)
Date: Fri, 28 Jul 2017 14:28:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> 
> 4 bytes is fixed size for reading or writing USB register. We
> will use a macro instead of hardcoding this.
> 
> Fixes: b97e9b94ad75c ("rsi: Add new host interface operations")
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

3 patches applied to wireless-drivers-next.git, thanks.

523b724a769b rsi: use macro for allocating USB buffer
59f73e2ae185 rsi: check length before USB read/write register
e6249e15fea2 rsi: fix static checker warning

-- 
https://patchwork.kernel.org/patch/9834829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
