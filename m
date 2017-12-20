Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754641AbdLTKPE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 05:15:04 -0500
Date: Wed, 20 Dec 2017 11:15:03 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BCM4356 does not initalize after firmware update
Message-ID: <20171220101502.GA25414@redhat.com> (sfid-20171220_111510_015621_DC2468E5)
References: <20171213161257.GB2811@redhat.com>
 <5A3240B9.90007@broadcom.com>
 <20171214142243.GB2737@redhat.com>
 <5A339CB2.1040202@broadcom.com>
 <20171215103215.GA2742@redhat.com>
 <5A33ADAA.9060008@broadcom.com>
 <20171215122045.GB2742@redhat.com>
 <5A38F9C4.3050202@broadcom.com>
 <20171219122340.GA13135@redhat.com>
 <5A3A2383.1080103@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A3A2383.1080103@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Dec 20, 2017 at 09:46:59AM +0100, Arend van Spriel wrote:
> I had my colleague run some tests as he has the device, but he is an ocean
> away. So he could get the new firmware running with nvram file. For the old
> firmware the device could boot without nvram, but the scan results were
> showing that the device was not operating optimally. Could you try the new
> firmware with the attached sample nvram file and let me know if that works
> for you?

Yes. After placing the nvram file to /lib/firmware/brcm/brcmfmac4356-pcie.txt
device now initalize with the new firmware. Is this right fix, IOW should this
file be shiped in linux-firmware ?

Thanks
Stanislaw
