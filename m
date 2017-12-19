Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753102AbdLSMXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:23:44 -0500
Date: Tue, 19 Dec 2017 13:23:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BCM4356 does not initalize after firmware update
Message-ID: <20171219122340.GA13135@redhat.com> (sfid-20171219_132348_732427_C23EB3F7)
References: <20171213161257.GB2811@redhat.com>
 <5A3240B9.90007@broadcom.com>
 <20171214142243.GB2737@redhat.com>
 <5A339CB2.1040202@broadcom.com>
 <20171215103215.GA2742@redhat.com>
 <5A33ADAA.9060008@broadcom.com>
 <20171215122045.GB2742@redhat.com>
 <5A38F9C4.3050202@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A38F9C4.3050202@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 19, 2017 at 12:36:36PM +0100, Arend van Spriel wrote:
> On 12/15/2017 1:20 PM, Stanislaw Gruszka wrote:
> >On Fri, Dec 15, 2017 at 12:10:34PM +0100, Arend van Spriel wrote:
> >># cat /sys/kernel/debug/brcmfmac/0000:03:00.0/revinfo
> >
> >vendorid: 0x14e4
> >deviceid: 0x43ec
> >radiorev: 0.41.32.105
> >chipnum: 17238 (4356)
> >chiprev: 2
> >chippkg: 2
> >corerev: 48
> >boardid: 0x0777
> >boardvendor: 0x14e4
> >boardrev: P103
> >driverrev: 7.35.180.119
> >ucoderev: 0
> >bus: 0
> >phytype: 11
> >phyrev: 17
> >anarev: 0
> >nvramrev: 00000000
> 
> Thanks for the info. I was looking for the board info. It seems we
> do not have an nvram file for that specific board.
> 
> For SDIO devices I would suggest to use the module parameter
> 'ignore_probe_fail' so we could do post-mortem stuff with the driver
> bound to the device, but for PCIe there are not much debug options.
> Let me work on that. May take a bit longer though.

What about the revert of the firmware change if proper
fix can not be soon available ?

Cheers
Stanislaw
