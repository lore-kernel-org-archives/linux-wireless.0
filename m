Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47060 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaGAMUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 08:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140701065721.GM24891@us.netrek.org>
References: <CALtMJEBWPM+75wxM2Mp5EX_o6NWtZUJdYRCv6psbvdUn4k295w@mail.gmail.com>
	<20140628052220.GG10407@us.netrek.org>
	<20140628072322.GC7410@atomide.com>
	<CALtMJED5vfgkAhMBXKaDP6u9U9n41c-wziyTxt6e_7XTSxG3oQ@mail.gmail.com>
	<20140630061912.GA2461@atomide.com>
	<53B1BAC1.3090902@zonque.org>
	<477F20668A386D41ADCC57781B1F70430FE5F37540@SC-VEXCH1.marvell.com>
	<20140701065721.GM24891@us.netrek.org>
Date: Tue, 1 Jul 2014 17:50:08 +0530
Message-ID: <CA+NduCAuRFTQneJUBiKP2Aeq2HCxe71yxg_iDDStkNvhzRg-Rg@mail.gmail.com> (sfid-20140701_142017_049627_EA2BE5CA)
Subject: Re: mwifiex card reset
From: Yuvaraj Cd <yuvaraj.lkml@gmail.com>
To: James Cameron <quozl@laptop.org>
Cc: Bing Zhao <bzhao@marvell.com>, Daniel Mack <daniel@zonque.org>,
	Tony Lindgren <tony@atomide.com>,
	Andreas Fenkart <afenkart@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Tomasz Figa <t.figa@samsung.com>,
	sunil joshi <joshi@samsung.com>, prashanth.g@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 1, 2014 at 12:27 PM, James Cameron <quozl@laptop.org> wrote:
> On Mon, Jun 30, 2014 at 11:44:29PM -0700, Bing Zhao wrote:
>> I may have missed something, but doesn't the MMC_POWER_OFF and
>> MMC_POWER_ON|UP handling in controller driver help?
>> Anyway the clocks/GPIOs/regulators are sort of platform
>> dependent. Would it be better putting it in /arch/arm/mach-xxxxx/?
>
> Wouldn't device tree for mmc be better?
I have come across same problem.Below is the thread in which more
discussions happened on this.
 http://patchwork.ozlabs.org/patch/312444/
I am adding few more those who are interested in this solution.
>
> --
> James Cameron
> http://quozl.linux.org.au/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
