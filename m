Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752880AbdCXGd3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 02:33:29 -0400
Date: Fri, 24 Mar 2017 07:33:13 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:STAGING - WILC1000 WIFI DRIVER"
        <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/staging/wilc1000: Fixing dev_err and removing
 dev_dbg calls for tracing
Message-ID: <20170324063313.GA16371@kroah.com> (sfid-20170324_073548_787861_F4B0E4B1)
References: <1490330321-7004-1-git-send-email-pushkar.iit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1490330321-7004-1-git-send-email-pushkar.iit@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 24, 2017 at 10:08:41AM +0530, Pushkar Jambhlekar wrote:
> dev_err: replacing function name with '%s' and __func__
> dev_dbg: Removing calls which are used for tracing a function.

That's two different things, so you need to send two different patches.

thanks,

greg k-h
