Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbeHLOOP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 10:14:15 -0400
Date: Sun, 12 Aug 2018 13:36:27 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 4/5] staging: wilc1000: change permission to 0600 in
 debugfs_create_file() call
Message-ID: <20180812113627.GD25209@kroah.com> (sfid-20180812_133631_874168_9186FEDC)
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
 <1534049265-5600-5-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534049265-5600-5-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 12, 2018 at 10:17:44AM +0530, Ajay Singh wrote:
> Cleanup patch to use more restrictive access permission for debugfs
> file.

Why?  What is the harm in writing to a value that is never used?  :)

thanks,

greg k-h
