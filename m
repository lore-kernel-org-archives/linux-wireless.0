Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbeDCUIY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 16:08:24 -0400
Date: Tue, 3 Apr 2018 22:08:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: License info
Message-ID: <20180403200823.GA18939@kroah.com> (sfid-20180403_220826_911883_F34478DF)
References: <fcdc6adf-6ced-7b0f-9196-e07bf9049e6e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fcdc6adf-6ced-7b0f-9196-e07bf9049e6e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 03, 2018 at 09:53:29PM +0200, Xose Vazquez Perez wrote:
> Larry Finger wrote:
> 
> > What is your position regarding license information? Should the standard GPL-V2 
> > boiler plate be replaced with "SPDX-License-Identifier: GPL-2.0" in wireless files?
> 
> "GPL-2.0" tag is deprecated [0] .
> 
> 
> It should be used:
> for GNU General Public License v2.0 only:     "GPL-2.0-only"
> for GNU General Public License v2.0 or later: "GPL-2.0-or-later"

Please read Documentation/process/license-rules.rst.  We are sticking
with the "old" SPDX identifiers for now as they changed after we already
started marking up the kernel source tree.

thanks,

greg k-h
