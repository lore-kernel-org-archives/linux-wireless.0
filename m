Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12254 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbcCXGvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 02:51:37 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v1 3/3] ath10k: Enable parsing per station rx duration for
 10.4
Date: Thu, 24 Mar 2016 06:51:18 +0000
Message-ID: <87d1qke5cq.fsf@kamboji.qca.qualcomm.com> (sfid-20160324_075141_911181_816BF22C)
References: <1458132214-4896-1-git-send-email-mohammed@qca.qualcomm.com>
	<1458132214-4896-3-git-send-email-mohammed@qca.qualcomm.com>
	<8737rhfiy7.fsf@kamboji.qca.qualcomm.com>
	<20160323130331.GA21534@atheros-ThinkPad-T61>
	<ec91f62c5b2a4c59b72df074d6ba37f0@aphydexm01b.ap.qualcomm.com>
In-Reply-To: <ec91f62c5b2a4c59b72df074d6ba37f0@aphydexm01b.ap.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Wed, 23 Mar 2016 13:08:32	+0000")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Shajakhan, Mohammed Shafi (Mohammed Shafi)" <mohammed@qti.qualcomm.com>
writes:
> I will make sure, I will run sparse before sending it for review
> http://linuxwireless.org/en/users/Drivers/ath10k/CodingStyle/#Linux_style
>
> make drivers/net/wireless/ath/ath10k/ C=2 CF="-D__CHECK_ENDIAN__"
>
> regret the inconvenience so caused  (including the compilation error)

I guess easier is to use my ath10k-check script:

https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-check

I use that script to test every patch before I commit them. Run the
script on the top level kernel source tree and ideally you should not
see any warnings (the output should be empty).

-- 
Kalle Valo