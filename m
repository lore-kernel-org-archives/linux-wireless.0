Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49296 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdLVIpm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 03:45:42 -0500
Message-ID: <1513932339.17825.0.camel@sipsolutions.net> (sfid-20171222_094546_590908_24725D39)
Subject: Re: [PATCH 0/6] wireless-regdb: Support for new binary database
 format
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>,
        linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Date: Fri, 22 Dec 2017 09:45:39 +0100
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
References: <20171222060303.14478-1-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-22 at 00:02 -0600, Seth Forshee wrote:
> This series starts with Johannes' patch for generating regulatory
> databases using the new format and adds various fixes and pieces which
> were missing such as installation to the firmware path, manual page
> updates, etc. It also restores support for the older database format to
> maintain compatibility with using CRDA on older kernels.
> 
> I've tested the results with 4.15 and things look to be working. I want
> to apply this in the next couple of days and get a new release out, so
> please let me know soon if you seen any issues.

Thanks!

johannes
