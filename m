Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46462 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966287Ab2EPNbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 09:31:31 -0400
Message-ID: <4FB3AC2B.8090601@candelatech.com> (sfid-20120516_153135_110747_2FB30C96)
Date: Wed, 16 May 2012 06:31:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Holger Schurig <holgerschurig@googlemail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k: Support ethtool getstats api.
References: <1337121205-24539-1-git-send-email-greearb@candelatech.com> <CAOpc7mH2hev-0E7cAucDGhu+6zDqTR9Rt7Ypz0hjQwsqDVCKbQ@mail.gmail.com>
In-Reply-To: <CAOpc7mH2hev-0E7cAucDGhu+6zDqTR9Rt7Ypz0hjQwsqDVCKbQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2012 11:12 PM, Holger Schurig wrote:
> Why did you link ethtool support to debugfs support?

The stats are only gathered when debugfs is enabled currently.

I'll work on a new config option to enable the ethtool stats
w/out ath9k debugfs once this patch goes in (and I get a bit
of time).

Thanks,
Ben

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
