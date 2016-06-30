Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39306 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbcF3KZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 06:25:24 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
	"Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for
 QCA99X0 and later
Date: Thu, 30 Jun 2016 10:25:16 +0000
Message-ID: <8760sr6kj8.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_122533_350358_5E575614)
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>
	<1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com>
	<576C1861.7020402@candelatech.com>
	<20160625185350.GA25330@atheros-ThinkPad-T61>
	<576F2165.3010109@candelatech.com>
In-Reply-To: <576F2165.3010109@candelatech.com> (Ben Greear's message of "Sat,
	25 Jun 2016 17:27:17 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> Is there a better way than posting to the ath10k mailing list?  There are quite
> a few more of my patches that are stuck in pending or ignored state.  If you
> could review some of them and add them to your testing trees then it might help
> them go upstream.

Yes, as you seem to test with your custom ath10k and custom firmware
review and testing feedback from others is more than welcome. That way I
can have more confidence that the patch really works with the mainline
version.

The problem with your patches is that you dump more responsibility on
me. I have no idea if they work with the mainline kernel, or if they
break something, so I need to personally test the patch and that takes
time. Basically I have a rule if that I need to use more than two
minutes on a patch it goes to the Deferred queue and I'll go through
that less often than the normal patch queue.

-- 
Kalle Valo