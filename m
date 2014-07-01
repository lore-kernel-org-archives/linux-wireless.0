Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41350 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916AbaGAHCe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 03:02:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: Daniel Mack <daniel@zonque.org>, Tony Lindgren <tony@atomide.com>,
	Andreas Fenkart <afenkart@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Tue, 1 Jul 2014 00:02:25 -0700
Subject: RE: mwifiex card reset
Message-ID: <477F20668A386D41ADCC57781B1F70430FE5F3754E@SC-VEXCH1.marvell.com> (sfid-20140701_090247_133209_90E89AA5)
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com>
 <20140628052220.GG10407@us.netrek.org> <20140628072322.GC7410@atomide.com>
 <CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com>
 <20140630061912.GA2461@atomide.com> <53B1BAC1.3090902@zonque.org>
 <477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
 <20140701065721.GM24891@us.netrek.org>
In-Reply-To: <20140701065721.GM24891@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> On Mon, Jun 30, 2014 at 11:44:29PM -0700, Bing Zhao wrote:
> > I may have missed something, but doesn't the MMC_POWER_OFF and
> > MMC_POWER_ON|UP handling in controller driver help?
> > Anyway the clocks/GPIOs/regulators are sort of platform dependent.
> > Would it be better putting it in /arch/arm/mach-xxxxx/?
> 
> Wouldn't device tree for mmc be better?

Yes, device tree is better for defining clocks/GPIO/regulators, etc.
But I guess the reset logic (making use of these definitions) cannot be device tree?

Regards,
Bing

> 
> --
> James Cameron
> http://quozl.linux.org.au/
