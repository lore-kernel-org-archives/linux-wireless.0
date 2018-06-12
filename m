Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932555AbeFLNOa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 09:14:30 -0400
Date: Tue, 12 Jun 2018 16:14:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nishad Kamdar <nishadkamdar@gmail.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Fix type of argument in
 ieee80211_is_action()
Message-ID: <20180612131413.qlv3wes43obfbmhe@mwanda> (sfid-20180612_151448_122775_8979F584)
References: <20180610071013.GA8771@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180610071013.GA8771@nishad>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 10, 2018 at 12:40:17PM +0530, Nishad Kamdar wrote:
> Type used is unsigned char but expected is restricted __le16.
> Warning reported by sparse. Part of eudyptula challenge.
> 

The code is buggy, but this fix just papers over it.  We discussed this
code earlier.

https://lkml.org/lkml/2018/6/5/304

regards,
dan carpenter
