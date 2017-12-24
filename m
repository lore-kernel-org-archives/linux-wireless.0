Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32778 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdLXDYf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 22:24:35 -0500
Received: from mail-it0-f72.google.com ([209.85.214.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSwtu-0002Ml-1c
        for linux-wireless@vger.kernel.org; Sun, 24 Dec 2017 03:24:34 +0000
Received: by mail-it0-f72.google.com with SMTP id r6so14484163itr.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Dec 2017 19:24:34 -0800 (PST)
Date: Sat, 23 Dec 2017 21:24:31 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Per Mejdal Rasmussen <pmr@its.aau.dk>
Subject: Re: [PATCH] wireless-regdb: Update rules for Denmark (DK)
Message-ID: <20171224032431.GA32049@ubuntu-xps13> (sfid-20171224_042437_903687_F3462723)
References: <20171222163808.27862-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171222163808.27862-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 22, 2017 at 10:38:08AM -0600, Seth Forshee wrote:
> Refresh the frequency ranges and power limits based on the
> following sources:
> 
>  https://erhvervsstyrelsen.dk/sites/default/files/007_interface-datanet_5-6_ghz.pdf.pdf
>  https://erhvervsstyrelsen.dk/sites/default/files/radiograenseflader-63.pdf
> 
> Cc: Per Mejdal Rasmussen <pmr@its.aau.dk>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied.
