Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55778 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaKUNR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 08:17:58 -0500
Message-ID: <1416575873.1881.7.camel@sipsolutions.net> (sfid-20141121_141805_567727_0626D120)
Subject: Re: [PATCH] mac80211_hwsim: Send alpha2 only if non-zero
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrik Flykt <patrik.flykt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 21 Nov 2014 14:17:53 +0100
In-Reply-To: <1416575282-19966-1-git-send-email-patrik.flykt@linux.intel.com>
References: <1416575282-19966-1-git-send-email-patrik.flykt@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 15:08 +0200, Patrik Flykt wrote:
> A properly set alpha2 value consists of two chars that both contain
> letters or digits. If no value is set, both chars keep their initial
> value zero. Therefore do not send the alpha2 parameter to user space
> if either of the characters has been left at its initial zero value.
> 
> Signed-off-by: Patrik Flykt <patrik.flykt@linux.intel.com>
> ---
> 
> This is a fix for the issue Johannes noted with the patch adding
> HWSIM_CMD_GET_RADIO support.

Interesting. I must have left the patch applied by accident. Oh well,
I'll apply this as well :)

johannes

