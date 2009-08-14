Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:26977 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZHNSol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 14:44:41 -0400
Received: by rv-out-0506.google.com with SMTP id f6so485026rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 11:44:42 -0700 (PDT)
Message-ID: <4A85B094.6010407@lwfinger.net>
Date: Fri, 14 Aug 2009 13:44:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: LP-PHY: Fix reading old mode in the set TX power
 control routine
References: <4A85AD1B.1060008@gmail.com>
In-Reply-To: <4A85AD1B.1060008@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Check the mode the hardware is in, not the mode we used the last time.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> Mark, please test if this fixes the TX power control WARN_ON you were
> seeing.

It does not fix it here. I'll take a look at the specs.

Larry
