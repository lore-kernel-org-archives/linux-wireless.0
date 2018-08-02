Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:20922 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbeHBKQ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 06:16:59 -0400
Date: Thu, 2 Aug 2018 13:56:49 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <ganesh.krishna@microchip.com>,
        <adham.abozaeid@microchip.com>, <aditya.shankar@microchip.com>
Subject: Re: [PATCH 8/8] staging: wilc1000: added parentheses in macro to
 avoid checkpatch issue
Message-ID: <20180802135649.13ea4059@ajaysk-VirtualBox> (sfid-20180802_102658_935376_F5ADEDF3)
In-Reply-To: <20180802073454.GC14107@kroah.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
 <1532844417-3192-9-git-send-email-ajay.kathat@microchip.com>
 <20180802073454.GC14107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 2 Aug 2018 09:34:54 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Jul 29, 2018 at 11:36:57AM +0530, Ajay Singh wrote:
> > Cleanup patch to fix below checkpatch reported issue:
> > -#define ISWILC1000(id)			((id & 0xfffff000)
> > == 0x100000 ? 1 : 0) +#define ISWILC1000(id)		(((id)
> > & 0xfffff000) == 0x100000 ? 1 : 0)
> 
> Even better, make this an inline function that returns a boolean to
> avoid any potental problems.
> 

Sure, I will make these changes and submit new patch.

Regards
Ajay
