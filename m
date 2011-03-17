Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40627 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1CQAiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:38:19 -0400
Received: by wya21 with SMTP id 21so2268528wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 17:38:18 -0700 (PDT)
Message-ID: <4D815772.6060006@gmail.com>
Date: Thu, 17 Mar 2011 00:36:02 +0000
From: Dave Kilroy <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Joe Gunn <armadefuego@yahoo.com>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH 2.6.38-rc8-wl 1/1] orinoco: Maintain lock
 until entry removed from list
References: <183581.36039.qm@web57402.mail.re1.yahoo.com>
In-Reply-To: <183581.36039.qm@web57402.mail.re1.yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/03/2011 15:41, Joe Gunn wrote:
> Removing an entry from the scan_list should be performed while holding the lock.
> Signed-off-by: Joseph J. Gunn<armadefuego@yahoo.com>
> ---

Agreed. Thanks,

Dave.
