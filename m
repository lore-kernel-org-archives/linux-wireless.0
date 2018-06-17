Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:34734 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932478AbeFQI1K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 04:27:10 -0400
Date: Sun, 17 Jun 2018 13:57:01 +0530
From: Nishad Kamdar <nishadkamdar@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Fix type of argument in
 ieee80211_is_action()
Message-ID: <20180617082700.GA2594@nishad> (sfid-20180617_102727_312061_71B80ACC)
References: <20180610071013.GA8771@nishad>
 <20180612131413.qlv3wes43obfbmhe@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180612131413.qlv3wes43obfbmhe@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 12, 2018 at 04:14:13PM +0300, Dan Carpenter wrote:
> On Sun, Jun 10, 2018 at 12:40:17PM +0530, Nishad Kamdar wrote:
> > Type used is unsigned char but expected is restricted __le16.
> > Warning reported by sparse. Part of eudyptula challenge.
> > 
> 
> The code is buggy, but this fix just papers over it.  We discussed this
> code earlier.
> 
> https://lkml.org/lkml/2018/6/5/304
> 
> regards,
> dan carpenter
> 

Ok, I will look at the discussion. Thanks for the review.

regards,
nishad kamdar
