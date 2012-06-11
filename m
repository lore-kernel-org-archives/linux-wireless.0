Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55331 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2FKFDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 01:03:41 -0400
Message-ID: <4FD57C18.5010401@qca.qualcomm.com> (sfid-20120611_070345_643357_7120E0DB)
Date: Mon, 11 Jun 2012 10:33:20 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <stable@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: Fix softlockup in AR9485
References: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com>	<20422.56106.127697.13731@gargle.gargle.HOWL>	<4FC702E4.9000906@qca.qualcomm.com>	<20423.1188.258292.959073@gargle.gargle.HOWL>	<4FC70737.1070708@qca.qualcomm.com> <20433.60690.664811.750413@gargle.gargle.HOWL>
In-Reply-To: <20433.60690.664811.750413@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Friday 08 June 2012 05:46 PM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>>> HZ can be configured to a user-defined value, so we need to make sure
>>> that the timing for the PLL work is what we want.
>>
>> ok, then we will change it.
>
> Shafi, will you be sending an updated version of this patch ?
> AR9485 is unusable currently - just bringing up the interface is
> enough to hang the machine...
>

i will send an updated version based on the latest wireless-testing 
tree. thanks.


-- 
thanks,
shafi
