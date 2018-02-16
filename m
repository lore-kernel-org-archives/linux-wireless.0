Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031559AbeBPQaq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 11:30:46 -0500
Date: Fri, 16 Feb 2018 17:30:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 00/12] fix to remove line over 80 chars and few other
Message-ID: <20180216163046.GA28916@kroah.com> (sfid-20180216_173049_693548_E72BCCCB)
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 16, 2018 at 08:41:37PM +0530, Ajay Singh wrote:
> This patch series contains changes to fix line over 80 characters,
> too many leading tabs and few other issues reported by checkpatch.pl
> script.

Please put the proper prefix on your 00/XX patches, that are with your
other patches.  Otherwise it can get lost in my patch queues...

thanks,

greg k-h
