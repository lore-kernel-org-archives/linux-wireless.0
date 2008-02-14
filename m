Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbYBNVe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 16:34:29 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [Ipw2100-devel] [RFT] ipw2200: fix ucode assertion for RX queue overrun
Date: Thu, 14 Feb 2008 13:28:50 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003ABC9AF@orsmsx416.amr.corp.intel.com> (sfid-20080214_213434_437095_57785E7F)
In-Reply-To: <47B48DE2.7000303@ludd.ltu.se>
References: <1202740070.2806.9.camel@localhost.localdomain><20080213235621.GA10003@Chamillionaire.breakpoint.cc> <47B48DE2.7000303@ludd.ltu.se>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Christian Fredriksson" <ille@ludd.ltu.se>,
	"Sebastian Siewior" <ipw+2200@ml.breakpoint.cc>
Cc: "Dan Williams" <dcbw@redhat.com>,
	<ipw2100-devel@lists.sourceforge.net>,
	"Zhu, Yi" <yi.zhu@intel.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Christian Fredriksson wrote:

> assertion for RX queue overrun
> 
> Sebastian Siewior wrote:
>> * Dan Williams | 2008-02-11 09:27:50 [-0500]:
>> 
>> 
>>> Restock the RX queue when there are a lot of unused frames so that
>>> the RX ring buffer doesn't overrun, causing a ucode assertion.
>>> Backport of patch "iwlwifi: fix ucode assertion for RX queue
>>> overrun". 
>>> 
>>> Signed-off-by: Dan Williams <dcbw@redhat.com>
>>> 
>> Tested-by: Sebastian Siewior <sebastian@breakpoint.cc>
>> 
>> 
>>> Sebastian, can you test and ensure that this works for you? Also,
>>> can 
>>> 
>> Yep, it does.
>> 
>> 
>>> you do some throughput testing to ensure that this patch doesn't
>>> cause a throughput regression?  Thanks!
>>> 
>> 00:49:41 (666.64 KB/s) - `/dev/null' saved [122563640/122563640]
>> 
>> this was a wget from the inet and it hits almost my cap. Currently I
>> don't have another local machine where I can test a "local" transfer.
>> 
>> Is this okey for you?
>> 
>> Sebastian
>> 
>> 
>> 
> The patch seem stable. Throughput are ok.
> 
> sftp> get 1001_20071125080100.mpg
> Fetching /myth/tv/1001_20071125080100.mpg to 1001_20071125080100.mpg
> /myth/tv/1001_20071125080100.mpg              100% 1120MB   2.6MB/s
> 07:16 sftp>
> 
> /Christian

Sounds great! 

Dan, could you please submit a final version - I'll ack it.

Thank you very much

Reinette
