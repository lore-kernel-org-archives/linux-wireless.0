Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40243 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcAVAny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 19:43:54 -0500
Subject: Re: [PATCH 00/13] ath10k: implement push-pull tx model
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56A17B49.7040703@candelatech.com> (sfid-20160122_014403_193636_F11BBEE2)
Date: Thu, 21 Jan 2016 16:43:53 -0800
MIME-Version: 1.0
In-Reply-To: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2016 05:46 AM, Michal Kazior wrote:
> This adds support for the new logic where host
> tells firmware how many frames are queued for each
> station/tid and then firmware asks host to submit
> frames for given station/tid.

Just FYI, with your tree (including this patch-set),
the non-upstream 10.4.1-ish firmware that was giving me fits finally works,
at least enough to grab an IP address.

Thanks!
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

