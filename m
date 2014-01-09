Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:31752 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbaAIOCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 09:02:35 -0500
Message-ID: <52CEAB24.5090700@neratec.com> (sfid-20140109_150301_500558_F6DEB551)
Date: Thu, 09 Jan 2014 14:59:00 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>	<1384665016-12022-5-git-send-email-sujith@msujith.org>	<52CE934D.1020400@neratec.com>	<21198.40916.260973.48444@gargle.gargle.HOWL>	<52CEA5A3.2040308@neratec.com> <21198.43395.235654.597422@gargle.gargle.HOWL>
In-Reply-To: <21198.43395.235654.597422@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2014 02:52 PM, Sujith Manoharan wrote:
> Wojciech Dubowik wrote:
>> AR9590 running on powerpc with latest openwrt i.e.
>> compat-wireless-2013-11-05 backported with
>> your changes for split pci/soc IQ calibration.
>>
>> I could try to reproduce it on my host with latest wireless testing if
>> you think
> It would also be good to know if this is a regression from this patch,
> so checking an older version of the driver without this patch would help.
It will take some time but I am on it.
> Sujith

