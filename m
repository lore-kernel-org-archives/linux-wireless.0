Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:55621 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1IZ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 04:25:27 -0400
Date: Tue, 28 Aug 2018 10:05:32 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <venkateswara.kaja@microchip.com>,
        <linux-wireless@vger.kernel.org>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 00/24] staging: wilc1000: avoid use of static and global
 variable
Message-ID: <20180828100532.03df5e26@ajaysk-VirtualBox> (sfid-20180828_063640_808354_E62FC3E4)
In-Reply-To: <20180827171047.GA5058@kroah.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <20180827171047.GA5058@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Mon, 27 Aug 2018 19:10:47 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, Aug 14, 2018 at 12:19:52PM +0530, Ajay Singh wrote:
> > This patch set mainly contains changes to avoid the use of static
> > and global variables. Also contains few patch to avoid the
> > checkpatch warning arise due to code refactor.  
> 
> I'm dropping this whole series from my review queue as I have no idea
> what is going on with it anymore :)

Sorry for the trouble.
Please ignore this patch set. I am working on v2 for this patch series
to include the review comments. 
I will send the updated patch set soon.


Regards,
Ajay
