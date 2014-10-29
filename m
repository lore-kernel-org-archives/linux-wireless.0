Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38814 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994AbaJ2QLN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 12:11:13 -0400
Message-ID: <1414599071.1827.28.camel@jlt4.sipsolutions.net> (sfid-20141029_171117_169002_A6F8E7EA)
Subject: Re: [PATCH v2] iw: support setting vif MAC during creation
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 17:11:11 +0100
In-Reply-To: <1414164942-23125-1-git-send-email-greearb@candelatech.com>
References: <1414164942-23125-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-24 at 08:35 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This saves an extra call to change it later, and will
> also keep udev from potentially messing with a vif
> it should not be messing with.

Applied.

johannes

