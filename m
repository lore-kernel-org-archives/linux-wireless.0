Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44710 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967225AbeEYQdo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 12:33:44 -0400
Received: from mail-io0-f198.google.com ([209.85.223.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fMFex-0005Ie-6m
        for linux-wireless@vger.kernel.org; Fri, 25 May 2018 16:33:43 +0000
Received: by mail-io0-f198.google.com with SMTP id r140-v6so4734149iod.16
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 09:33:43 -0700 (PDT)
Date: Fri, 25 May 2018 11:33:39 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Mathieu =?utf-8?Q?Peyr=C3=A9ga?= <mathieu.peyrega@gmail.com>
Subject: Re: [PATCH] wireless-regdb: Add 5725-5875 MHz rule for France (FR)
Message-ID: <20180525163339.GU3401@ubuntu-xps13> (sfid-20180525_183430_006043_DD7CCF7C)
References: <20180515191126.19189-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180515191126.19189-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2018 at 02:11:26PM -0500, Seth Forshee wrote:
> Based on [1] and [2], use of short range devices in this range
> is now permitted in France. Add a rule for this range, using the
> power limit of 25 dBm as specified in these documents and in
> ETSI EN 300 440.
> 
> [1] https://www.arcep.fr/uploads/tx_gsavis/14-1263.pdf
> [2] https://www.arcep.fr/uploads/tx_gsavis/14-1263.pdf
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied.
