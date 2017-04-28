Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756211AbdD1KCF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 06:02:05 -0400
Date: Fri, 28 Apr 2017 12:01:50 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        "# v4 . 9+" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: vt6656: use off stack for out buffer USB
 transfers.
Message-ID: <20170428100150.GA29304@kroah.com> (sfid-20170428_120244_466003_5E4F2B76)
References: <20170422101458.4566-1-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170422101458.4566-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 22, 2017 at 11:14:57AM +0100, Malcolm Priestley wrote:
> Since 4.9 mandated USB buffers be heap allocated this causes the driver
> to fail.

It's really been a requirement since the 2.2 days, it's just that not
many people ran USB drivers on the platforms that required it :)

thanks,

greg k-h
