Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41311 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0JLMf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 08:35:56 -0400
Received: by wwj40 with SMTP id 40so4958262wwj.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 05:35:55 -0700 (PDT)
Date: Tue, 12 Oct 2010 14:29:56 +0200
From: Ido Yariv <ido@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/4] wl1271: Allocate TX descriptors more efficiently
Message-ID: <20101012122955.GX1836@WorkStation>
References: <1286873633-10080-1-git-send-email-ido@wizery.com>
 <1286873633-10080-4-git-send-email-ido@wizery.com>
 <1286884921.3753.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286884921.3753.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 02:02:01PM +0200, Johannes Berg wrote:
> Just use
> 	unsigned long tx_frames_map[BITS_TO_LONGS(ACX_TX_DESCRIPTORS)];
> instead and you don't have to worry about the number anywhere.

Good idea, thanks!
