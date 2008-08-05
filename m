Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:56574 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761323AbYHEPgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 11:36:49 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2649612rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 08:36:49 -0700 (PDT)
Message-ID: <1ba2fa240808050836k225fd3ecu632177394b1fd42a@mail.gmail.com> (sfid-20080805_173718_428869_8CECDB81)
Date: Tue, 5 Aug 2008 18:36:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 00/10] iwlwifi driver 08/04 updates
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080805130320.GA4276@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
	 <1217918197.3107.64.camel@debian.sh.intel.com>
	 <20080805130320.GA4276@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 5, 2008 at 4:03 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Aug 05, 2008 at 02:36:37PM +0800, Zhu Yi wrote:
>> On Mon, 2008-08-04 at 16:00 +0800, Zhu Yi wrote:
>> > Hi John,
>> >
>> > Here is another series of iwlwifi driver update. Note, the patch 10/10 fixes
>> > a merge problem for wireless-testing GIT with upstream.
>> >
>> > Thanks,
>> > -yi
>> >
>> > [PATCH 01/10] iwlwifi: HW bug fixes
>> > [PATCH 02/10] iwlwifi: memory allocation optimization
>> > [PATCH 03/10] iwlwifi: kill struct iwl4965_lq_mngr
>> > [PATCH 04/10] iwlwifi: implement iwl5000_calc_rssi
>> > [PATCH 05/10] iwlwifi: fix unhandled interrupt when HW rfkill is on
>> > [PATCH 06/10] iwlwifi: cleanup iwl_tx_skb
>> > [PATCH 07/10] iwlwifi: add level for debugging host command
>> > [PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort handler
>> > [PATCH 09/10] iwlwifi: grap nic access before accessing periphery registers
>> > [PATCH 10/10] iwl3945: fix merge mistake for packet injection
>>
>> Hi John,
>>
>> I see you merged only partial of this series. What's happen to the
>> patches 03, 06 and 07?
>
> I don't see those as fixes, only cleanups.  The merge window is closed
> for 2.6.27.  If those are in fact fixes then please explain.

Fine with me, I just would ask you to include 06 anyway I see we have
problem with queues in this code I would like to make fixes on top if
it.
Thanks
Tomas
