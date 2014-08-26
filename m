Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:13062 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934147AbaHZIvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 04:51:07 -0400
Message-ID: <53FC4A78.2040407@broadcom.com> (sfid-20140826_105113_726049_D53C9674)
Date: Tue, 26 Aug 2014 10:51:04 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Brain WrecK <bloften80@gmail.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43241b4-sdio NVRAM help request
References: <CAA1t8Su1N6vCCnFgJ3hgWXptFC0arSWqE67REWsnWtO9LcrrrQ@mail.gmail.com>
In-Reply-To: <CAA1t8Su1N6vCCnFgJ3hgWXptFC0arSWqE67REWsnWtO9LcrrrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/14 10:06, Brain WrecK wrote:
> Hello Sir
>
> I am writing this request to ask for your aid, we have been tryng to get
> ubuntu 14.10 to run on an ASUS T100TA tablet and we are having wifi issues
>
> I am appealing to you and to ask for your help as i have been trying for
> weeks to get this wifi working stable, i have been trying to modify the
> NVRAM file to get a stable connection so we can have decent working
> internet on this tablet to enjoy the Linux experience. right now
> currently we can download in the range of 600 bytes/sec to maybe 10kb/sec
>
> We are unable to connect with the current NVRAM file provided from the
> NVRAM file unless we put our current MAC address for our wifi card in
> the brcmfmac43241b4-sdio.txt
>
> and once we do that we are able to connect but we get frequent
> disconnects and very very slow download rates...
>
> I have pulled the NVRAM from the efivars in sys/firmware/efivars and
> have attached it for you is there perhaps an updated file that will
> work, or would you be able to help us and create a new or provide a
> current NVRAM File?
>
> Also the firmware that is provided for us is dated july 17th 2013 is
> there an updated linux firmware that we can use for this device that
> perhaps would have an updated NVRAM file to go with it?
>
> I have attached the firmware that is provided for us as well for your
> reference
>
> I am sure you are a busy person and we in the linux community would love
> to be rid of windows and enjoy the linux experience, could you, would
> you lend us your aid?

Hi Brian,

Sure I can try to be somewhat helpful. I am currently on vacation and 
rain is pouring down in buckets.

The nvram that is in EFI should be the perfect fit for the device. Maybe 
you can provide some more background info. Are you using stock ubuntu 
kernel. What kernel version is running? Can you boot the kernel with 
'debug ignore_loglevel' parameters, load the brcmfmac driver with 
'debug=0xd416', and send me the full kernel log.

Regards,
Arend
