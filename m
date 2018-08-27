Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60704 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbeH0U6W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 16:58:22 -0400
Date: Mon, 27 Aug 2018 19:10:47 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 00/24] staging: wilc1000: avoid use of static and global
 variable
Message-ID: <20180827171047.GA5058@kroah.com> (sfid-20180827_191059_821834_11EC370A)
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 12:19:52PM +0530, Ajay Singh wrote:
> This patch set mainly contains changes to avoid the use of static
> and global variables. Also contains few patch to avoid the checkpatch
> warning arise due to code refactor.

I'm dropping this whole series from my review queue as I have no idea
what is going on with it anymore :)

Please fix up and resend.

thanks,

greg k-h
