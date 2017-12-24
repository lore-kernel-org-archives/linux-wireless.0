Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32775 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdLXDYN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 22:24:13 -0500
Received: from mail-io0-f197.google.com ([209.85.223.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSwtY-0002JB-4h
        for linux-wireless@vger.kernel.org; Sun, 24 Dec 2017 03:24:12 +0000
Received: by mail-io0-f197.google.com with SMTP id n62so9733699iod.17
        for <linux-wireless@vger.kernel.org>; Sat, 23 Dec 2017 19:24:12 -0800 (PST)
Date: Sat, 23 Dec 2017 21:24:08 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/6] wireless-regdb: Support for new binary database
 format
Message-ID: <20171224032408.GA31806@ubuntu-xps13> (sfid-20171224_042417_334732_7EBD0C35)
References: <20171222060303.14478-1-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 22, 2017 at 12:02:57AM -0600, Seth Forshee wrote:
> This series starts with Johannes' patch for generating regulatory
> databases using the new format and adds various fixes and pieces which
> were missing such as installation to the firmware path, manual page
> updates, etc. It also restores support for the older database format to
> maintain compatibility with using CRDA on older kernels.
> 
> I've tested the results with 4.15 and things look to be working. I want
> to apply this in the next couple of days and get a new release out, so
> please let me know soon if you seen any issues.

Applied.
