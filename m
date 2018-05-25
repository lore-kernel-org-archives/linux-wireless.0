Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44724 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967069AbeEYQeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 12:34:15 -0400
Received: from mail-it0-f72.google.com ([209.85.214.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fMFfS-0005Jq-PZ
        for linux-wireless@vger.kernel.org; Fri, 25 May 2018 16:34:14 +0000
Received: by mail-it0-f72.google.com with SMTP id m12-v6so4812971ita.6
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 09:34:14 -0700 (PDT)
Date: Fri, 25 May 2018 11:34:11 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Fix iteration in create_wmms() for
 python 3
Message-ID: <20180525163411.GX3401@ubuntu-xps13> (sfid-20180525_183431_678696_FB9AD370)
References: <20180518171725.28828-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180518171725.28828-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 18, 2018 at 12:17:25PM -0500, Seth Forshee wrote:
> The iteration in this function is over countries.itervalues(),
> which is not compatible with python 3. Switch to iterating over
> contries.values() instead.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied.
