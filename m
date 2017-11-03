Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32888 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756113AbdKCRgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 13:36:33 -0400
Received: from mail-io0-f199.google.com ([209.85.223.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eAftQ-0001Hj-Lp
        for linux-wireless@vger.kernel.org; Fri, 03 Nov 2017 17:36:32 +0000
Received: by mail-io0-f199.google.com with SMTP id 101so9974803ioj.6
        for <linux-wireless@vger.kernel.org>; Fri, 03 Nov 2017 10:36:32 -0700 (PDT)
Date: Fri, 3 Nov 2017 12:36:30 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: =?utf-8?B?0JDQvdC00YDQtdC5INCY0LLQsNC90L7Qsg==?= <wowz89@mail.ru>
Subject: Re: [PATCH v2] wireless-regdb: Add 5 Ghz rules for Kazakhstan (KZ)
Message-ID: <20171103173630.dlkvsa63e6n75wgw@ubuntu-xps13> (sfid-20171103_183648_736038_5242FF47)
References: <20171020150651.32424-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020150651.32424-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 20, 2017 at 10:06:51AM -0500, Seth Forshee wrote:
> Add rules for 5150-5250 MHz, 5250-5350 MHz, and 5470-5725 Mhz
> based on the documents at [1] and [2].
> 
> v2: Also add DFS region
> 
> [1] http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
> [2] http://adilet.zan.kz/rus/docs/P000001379_
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied.
