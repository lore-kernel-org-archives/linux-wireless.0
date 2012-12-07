Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19559 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2LGG4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 01:56:21 -0500
Message-ID: <50C19303.5060608@qca.qualcomm.com> (sfid-20121207_075633_159031_13784203)
Date: Fri, 7 Dec 2012 12:26:03 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC V3 1/2] I'dcfg80211: Move the definition of struct mac_address
 up
References: <1354853850-10537-1-git-send-email-vthiagar@qca.qualcomm.com> <1354858735.22463.31.camel@joe-AO722>
In-Reply-To: <1354858735.22463.31.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Friday 07 December 2012 11:08 AM, Joe Perches wrote:
> On Fri, 2012-12-07 at 09:47 +0530, Vasanthakumar Thiagarajan wrote:
>> struct mac_address will be used by ACL related configuration ops.
>
> I'd prefer that any new code _not_ use struct mac_address
> but use u8 addr[ETH_ALEN] instead.
>
> That's the most common style in the kernel.

Ok, but struct mac_address looked handy when I want
to deal with list of mac address instead using linked
list. Thanks!

Vasanth
