Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34907 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbbALTxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:53:07 -0500
Message-ID: <54B42622.5090404@candelatech.com> (sfid-20150112_205315_086941_BA32950E)
Date: Mon, 12 Jan 2015 11:53:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/8] ath10k: scan should handle scan-start-failed event
 properly.
References: <1421090992-14971-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1421090992-14971-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry about the resends...had mail-server issue, should be resolved now.

Thanks,
Ben

On 01/12/2015 11:29 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> In case firmware fails to start the scan, then complete
> the start condition and clean up so that driver does not
> block on timeout.


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

