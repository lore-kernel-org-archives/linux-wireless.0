Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44329 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354AbaDITaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 15:30:08 -0400
Message-ID: <53459FA0.9020700@candelatech.com> (sfid-20140409_213012_924309_6218CF6E)
Date: Wed, 09 Apr 2014 12:29:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> <5341F1A9.2030202@candelatech.com> <CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com> <53435F89.60500@candelatech.com> <CA+BoTQk6G4-h8HQENbK9snrXo6j6FW4D+07XKZMEEuvWiu03ww@mail.gmail.com> <53441D95.9000409@candelatech.com> <CA+BoTQkCDiUiV7dsg-myOZXQEB=B7JHH8NWm5BHsp1xExjLkSA@mail.gmail.com> <5345849A.5090603@candelatech.com>
In-Reply-To: <5345849A.5090603@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2014 10:34 AM, Ben Greear wrote:

> This is with your RFTv2 patches on top of some of my patches and
> recent wl-ath tree.  This is using my modified firmware since this
> test case cannot work at all on standard firmware.
> 
> Let me know if I can offer any additional logs or info.

By the way, I reproduced the general problem with only your first two
patches (from previous RFT series) applied.  It is at least a bit
harder to reproduce, but it can happen.

Possibly the causes of the failure to flush are different in that
case, so it may not really be quite the same issue.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

