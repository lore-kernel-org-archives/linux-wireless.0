Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32899 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424066AbdD1QLS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 12:11:18 -0400
Received: by mail-pg0-f68.google.com with SMTP id v20so3584901pgn.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Apr 2017 09:11:17 -0700 (PDT)
Date: Fri, 28 Apr 2017 10:11:10 -0600
From: Jason Litzinger <jlitzingerdev@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH RFC] staging: wilc1000: Refactor handling of HT caps
 fields
Message-ID: <20170428161110.GA959@arch-tinker.localdomain> (sfid-20170428_181148_089209_29490CDA)
References: <20170426044625.20529-1-jlitzingerdev@gmail.com>
 <20170428095857.GA22700@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170428095857.GA22700@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So are you going to resend this as a non-RFC patch so that I can apply
> it?  :)
Yep, apologies for the delay.

Was hoping to get my test setup up and going, but some Errata with
that version of the dev board have complicated access to the SDIO port.
I'll prepare a proper patch and get it sent out tonight (tomorrow
latest) after I update my trees and do the usual build/apply/test cycle.

Thanks,
-Jason Litzinger
