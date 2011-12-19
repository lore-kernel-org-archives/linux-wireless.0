Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35507 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1LSP31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 10:29:27 -0500
Message-ID: <4EEF5834.8080408@candelatech.com> (sfid-20111219_162930_411193_76FA2B00)
Date: Mon, 19 Dec 2011 07:28:52 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH 1/2] nl80211: add support for mcs masks
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1324304099-18327-2-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1324304099-18327-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/2011 06:14 AM, Simon Wunderlich wrote:
> Allow to set mcs masks through nl80211. We also allow to set MCS
> rates but no legacy rates (and vice versa).

Can you not use the ht-caps logic that went in recently?  I was able
to successfully set station MCS rates with it.  It only works for
station devices at this point...but AP support could probably be
added without too much trouble.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
