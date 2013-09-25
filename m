Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:58112 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3IYQhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 12:37:40 -0400
Message-ID: <52431148.6000706@gmail.com> (sfid-20130925_221655_265665_416AEF23)
Date: Wed, 25 Sep 2013 18:37:28 +0200
From: Daniel Mack <zonque@gmail.com>
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: Paul Stewart <pstew@google.com>, Dylan Reid <dgreid@chromium.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"s.neumann@raumfeld.com" <s.neumann@raumfeld.com>,
	"afenkart@gmail.com" <afenkart@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 3.12] mwifiex: queue main work from main process when
 bailing on races
References: <1379442330-18249-1-git-send-email-zonque@gmail.com> <477F20668A386D41ADCC57781B1F70430F44C5880A@SC-VEXCH1.marvell.com> <5242F1D7.4040404@gmail.com> <477F20668A386D41ADCC57781B1F70430F45077CCF@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F45077CCF@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On 25.09.2013 18:19, Bing Zhao wrote:
>>> Acked-by: Bing Zhao <bzhao@marvell.com>
>> 
>> John, could you pick this one?
> 
> We found that this patch causes CPU utilization issue on
> Chromebooks. Could you please try attached patch on your platform?
> Basically this patch reverts your change and add main_proc_lock
> protection for int_status and IS_CARD_RX_RCVD access to avoid the
> missing interrupt handling.

Ok, that seems to work fine for me as well. Thanks for the update :)

Fell free to add my

	Tested-by: Daniel Mack <zonque@gmail.com>

if you need it.


Thanks,
Daniel

