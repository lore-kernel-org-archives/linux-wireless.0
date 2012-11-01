Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab2KAJqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 05:46:32 -0400
Date: Thu, 1 Nov 2012 11:46:28 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"Porter, Matt" <mporter@ti.com>
Subject: Re: mwifiex_sdio problem: firmware fails to be active in time
Message-ID: <20121101094626.GB17693@aemeltch-MOBL1> (sfid-20121101_104644_795973_786316D4)
References: <507F4448.2040707@gmail.com>
 <477F20668A386D41ADCC57781B1F7043083B80E44A@SC-VEXCH1.marvell.com>
 <50802984.6070203@gmail.com>
 <CAMXE1-qWOKphtOjUYWUz1CLDUtAynODvHmLm60rJMC=jBtRsNw@mail.gmail.com>
 <508AF992.8070606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <508AF992.8070606@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mack,

On Fri, Oct 26, 2012 at 10:58:58PM +0200, Daniel Mack wrote:
> [have to re-open this issue again]
> 
> On 21.10.2012 16:16, Andrei Emeltchenko wrote:
> > I have the same board and see this problem sometimes. Reloading modules
> > might help, if not reboot always works :).
> 
> I thought I solved this issue, but I can't reproduce the running version
> anymore unfortunately. It constantly fails with the error I described,
> even though the clock and all voltages etc are definitely stable. I can
> also rule out hardware issues as the BSP kernel (3.2.18) works just fine
> with the same setup including the firmware image.
> 
> Andrei, may I ask which board you have exactly? 

I do not know exactly, it is MARVELL RD8787 AG1_V3 with WIB Adapter v3.

> What kernel version are
> you based on? 

I use latest bluetooth-next which is 3.7-rc1 + some bluetooth & wireless patches

Best regards 
Andrei Emeltchenko 


