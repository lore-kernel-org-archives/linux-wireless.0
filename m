Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53098 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbcCXHCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 03:02:06 -0400
Date: Thu, 24 Mar 2016 12:31:52 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v1 3/3] ath10k: Enable parsing per station rx duration
 for 10.4
Message-ID: <20160324070152.GA23410@atheros-ThinkPad-T61> (sfid-20160324_080245_214166_5595B9EC)
References: <1458132214-4896-1-git-send-email-mohammed@qca.qualcomm.com>
 <1458132214-4896-3-git-send-email-mohammed@qca.qualcomm.com>
 <8737rhfiy7.fsf@kamboji.qca.qualcomm.com>
 <20160323130331.GA21534@atheros-ThinkPad-T61>
 <ec91f62c5b2a4c59b72df074d6ba37f0@aphydexm01b.ap.qualcomm.com>
 <87d1qke5cq.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d1qke5cq.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Thu, Mar 24, 2016 at 06:51:18AM +0000, Valo, Kalle wrote:
> "Shajakhan, Mohammed Shafi (Mohammed Shafi)" <mohammed@qti.qualcomm.com>
> writes:
> > I will make sure, I will run sparse before sending it for review
> > http://linuxwireless.org/en/users/Drivers/ath10k/CodingStyle/#Linux_style
> >
> > make drivers/net/wireless/ath/ath10k/ C=2 CF="-D__CHECK_ENDIAN__"
> >
> > regret the inconvenience so caused  (including the compilation error)
> 
> I guess easier is to use my ath10k-check script:
> 
> https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-check
> 
> I use that script to test every patch before I commit them. Run the
> script on the top level kernel source tree and ideally you should not
> see any warnings (the output should be empty).
>

[shafi] sure will do that.

regards,
shafi
