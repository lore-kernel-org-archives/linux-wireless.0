Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:34154 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409AbaGAHD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 03:03:58 -0400
Date: Tue, 1 Jul 2014 17:03:49 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: Daniel Mack <daniel@zonque.org>, Tony Lindgren <tony@atomide.com>,
	Andreas Fenkart <afenkart@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: mwifiex card reset
Message-ID: <20140701070349.GN24891@us.netrek.org> (sfid-20140701_090404_820964_884D4864)
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com>
 <20140628052220.GG10407@us.netrek.org>
 <20140628072322.GC7410@atomide.com>
 <CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com>
 <20140630061912.GA2461@atomide.com>
 <53B1BAC1.3090902@zonque.org>
 <477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
 <20140701065721.GM24891@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430FE5F3754E@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430FE5F3754E@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 01, 2014 at 12:02:25AM -0700, Bing Zhao wrote:
> Hi James,
> 
> > On Mon, Jun 30, 2014 at 11:44:29PM -0700, Bing Zhao wrote:
> > > I may have missed something, but doesn't the MMC_POWER_OFF and
> > > MMC_POWER_ON|UP handling in controller driver help?
> > > Anyway the clocks/GPIOs/regulators are sort of platform dependent.
> > > Would it be better putting it in /arch/arm/mach-xxxxx/?
> > 
> > Wouldn't device tree for mmc be better?
> 
> Yes, device tree is better for defining clocks/GPIO/regulators, etc.
> But I guess the reset logic (making use of these definitions) cannot
> be device tree?

I think the reset logic can exist, but does nothing unless the device
tree definitions are present.

-- 
James Cameron
http://quozl.linux.org.au/
