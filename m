Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:35441 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929AbaGONZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 09:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Xi5B2=tssgQSgjeKtYVcw-x9pS6Ci580M6OfroPCb+RA@mail.gmail.com>
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com>
	<20140628052220.GG10407@us.netrek.org>
	<20140628072322.GC7410@atomide.com>
	<CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com>
	<20140630061912.GA2461@atomide.com>
	<53B1BAC1.3090902@zonque.org>
	<477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
	<20140701065721.GM24891@us.netrek.org>
	<CA+NduCAuRFTQneJUBiKP2Aeq2HCxe71yxg_iDDStkNvhzRg-Rg@mail.gmail.com>
	<CAD=FV=Xi5B2=tssgQSgjeKtYVcw-x9pS6Ci580M6OfroPCb+RA@mail.gmail.com>
Date: Tue, 15 Jul 2014 15:25:17 +0200
Message-ID: <CALtMJEBWVgxbc+Kqna41EBSc8Rwn=jFO-3BNjNWibvp6EQvAUg@mail.gmail.com> (sfid-20140715_152526_337097_38E7A3CA)
Subject: Re: mwifiex card reset
From: Andreas Fenkart <afenkart@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Yuvaraj Cd <yuvaraj.lkml@gmail.com>,
	Olof Johansson <olof@lixom.net>,
	James Cameron <quozl@laptop.org>,
	Bing Zhao <bzhao@marvell.com>, Daniel Mack <daniel@zonque.org>,
	Tony Lindgren <tony@atomide.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Tomasz Figa <t.figa@samsung.com>,
	sunil joshi <joshi@samsung.com>,
	Prashanth G <prashanth.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-07-01 17:09 GMT+02:00 Doug Anderson <dianders@chromium.org>:
> +Olof who posted the patch that Yuvaraj referenced.
>
> On Tue, Jul 1, 2014 at 5:20 AM, Yuvaraj Cd <yuvaraj.lkml@gmail.com> wrote:
>> On Tue, Jul 1, 2014 at 12:27 PM, James Cameron <quozl@laptop.org> wrote:
>>> On Mon, Jun 30, 2014 at 11:44:29PM -0700, Bing Zhao wrote:
>>>> I may have missed something, but doesn't the MMC_POWER_OFF and
>>>> MMC_POWER_ON|UP handling in controller driver help?
>>>> Anyway the clocks/GPIOs/regulators are sort of platform
>>>> dependent. Would it be better putting it in /arch/arm/mach-xxxxx/?
>>>
>>> Wouldn't device tree for mmc be better?
>> I have come across same problem.Below is the thread in which more
>> discussions happened on this.
>>  http://patchwork.ozlabs.org/patch/312444/
>> I am adding few more those who are interested in this solution.
>
> Thanks to Yuvaraj for referencing the old thread.

http://www.spinics.net/lists/linux-mmc/msg26564.html

Quite a read indeed

Meanwhile I got a working prototype for omap_hsmmc/mwifiex based on this series:
http://www.spinics.net/lists/linux-mmc/msg27228.html

I will post my patches, once the FDT format is set in stone, and Ulf
has had some time to work on v2 of his series.
