Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33381 "EHLO
        mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbcJJUyc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 16:54:32 -0400
Received: by mail-pa0-f54.google.com with SMTP id vu5so1077392pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2016 13:54:32 -0700 (PDT)
Date: Mon, 10 Oct 2016 13:54:29 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com
Subject: Re: [PATCH v4 2/3] mwifiex: remove redundant pdev check in
 suspend/resume handlers
Message-ID: <20161010205428.GC11254@localhost> (sfid-20161010_225435_950752_C798A635)
References: <1475777186-20486-1-git-send-email-akarwar@marvell.com>
 <1475777186-20486-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475777186-20486-2-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 06, 2016 at 11:36:25PM +0530, Amitkumar Karwar wrote:
> to_pci_dev() would just do struct offset arithmetic on struct
> device to get 'pdev' pointer. We never get NULL pdev pointer
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> New patch introduced in v3 as per inputs from Brian Norris.
> v4: Same as v3
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)

Reviewed-by: Brian Norris <briannorris@chromium.org>
