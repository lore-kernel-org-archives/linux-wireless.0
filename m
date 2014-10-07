Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45462 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbaJGIqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 04:46:34 -0400
Message-ID: <1412671591.1825.2.camel@jlt4.sipsolutions.net> (sfid-20141007_104650_832790_03F606BD)
Subject: Re: [PATCH 1/3] mac-hwsim:  don't leak memory on tx failure.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Oct 2014 10:46:31 +0200
In-Reply-To: <1411680140-20208-1-git-send-email-greearb@candelatech.com> (sfid-20140925_232227_177632_9B1F32D8)
References: <1411680140-20208-1-git-send-email-greearb@candelatech.com>
	 (sfid-20140925_232227_177632_9B1F32D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-25 at 14:22 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> It seems previous code did not properly clean up memory
> if the packet could not be delivered to user-space.

Applied, also patch #3.

johannes

