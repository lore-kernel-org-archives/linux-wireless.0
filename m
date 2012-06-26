Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14107 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab2FZH2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 03:28:13 -0400
Message-ID: <4FE96485.6080504@qca.qualcomm.com> (sfid-20120626_092816_542186_F1659CB2)
Date: Tue, 26 Jun 2012 12:58:05 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH v3 09/10] ath9k: Add WoW related mac80211 callbacks
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>		<1340633579-7514-10-git-send-email-mohammed@qca.qualcomm.com>	 <20456.47690.633636.869442@gargle.gargle.HOWL>	 <4FE9477E.5000902@qca.qualcomm.com> (sfid-20120626_072440_884254_F5CE58F6) <1340693409.4662.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340693409.4662.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tuesday 26 June 2012 12:20 PM, Johannes Berg wrote:
> On Tue, 2012-06-26 at 10:54 +0530, Mohammed Shafi Shajakhan wrote:
>
>> the user pattern needs bit more stuff, we need to convert it to our chip
>> specific format(ie proper 802.11 format), previously there was
>> a logic of duplicate patterns before programming to HW, where a list in
>> the driver was necessary, i removed it to simplify few things.
>
> You might consider adding new API for 802.11-based patterns as the 802.3
> patterns could match multiple 802.11 frames etc.
>

thanks for your suggestion, i shall come with an API to do this.

-- 
thanks,
shafi
