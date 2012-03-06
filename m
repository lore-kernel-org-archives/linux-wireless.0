Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27750 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2CFFG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 00:06:28 -0500
Message-ID: <4F559B4D.5030006@qca.qualcomm.com> (sfid-20120306_060632_663145_A5F3CE29)
Date: Tue, 6 Mar 2012 10:36:21 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<senthilb@qca.qualcomm.com>, <vthiagar@qca.qualcomm.com>,
	<rodrigue@qca.qualcomm.com>,
	Rajkumar_contact <rmanohar@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>
Subject: Re: [RFC 1/2] ath9k: use ieee80211_free_txskb
References: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com> <4F4F7DC2.8030204@qca.qualcomm.com> <4F54D53D.80300@qca.qualcomm.com> <201203051943.15875.chunkeey@googlemail.com>
In-Reply-To: <201203051943.15875.chunkeey@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> would you like me to test this patch,
> ? Sure, I would like someone with a AR9300+ to test the patch.
> Currently, I'm stuck with a puny AR9287 [in a router].
> So, I can't run tests all day :(.
>
>> i can just ran a bidirectional traffic test parallel y enabling
>> PAPRD,with this proposed patch.
> Actually, the changes are all within ath9k's tx error paths. So,
> I'm afraid just continuous traffic testing won't do, unless of course
> you can churn out all sorts of tx (dma) errors at the same time.

yes, i can just a start stress test that can run few days in a noisy 
channel, with the AR9300 card.

>
> Regards,
> 	Chr


-- 
thanks,
shafi
