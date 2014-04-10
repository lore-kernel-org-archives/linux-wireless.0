Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4815 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934583AbaDJDps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 23:45:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<5341F1A9.2030202@candelatech.com>
	<CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com>
	<53435F89.60500@candelatech.com>
	<CA+BoTQk6G4-h8HQENbK9snrXo6j6FW4D+07XKZMEEuvWiu03ww@mail.gmail.com>
	<53441D95.9000409@candelatech.com>
	<CA+BoTQkCDiUiV7dsg-myOZXQEB=B7JHH8NWm5BHsp1xExjLkSA@mail.gmail.com>
	<5345849A.5090603@candelatech.com>
Date: Thu, 10 Apr 2014 06:45:39 +0300
In-Reply-To: <5345849A.5090603@candelatech.com> (Ben Greear's message of "Wed,
	09 Apr 2014 10:34:18 -0700")
Message-ID: <87eh15j198.fsf@kamboji.qca.qualcomm.com> (sfid-20140410_054611_966915_B93FCDCA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> My version of supplicant does not support -T.  I have just sync'd down the
> latest upstream hostapd code and will see if that adds the support.

You need to enable CONFIG_DEBUG_LINUX_TRACING in wpasupplicant.

http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing

-- 
Kalle Valo
