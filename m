Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44591 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1FHTqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 15:46:43 -0400
Received: by pwi15 with SMTP id 15so401785pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2011 12:46:42 -0700 (PDT)
Date: Wed, 8 Jun 2011 22:46:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] ath6kl: testmode support
Message-ID: <20110608194618.GB4069@shale.localdomain> (sfid-20110608_214648_016083_5855B921)
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
 <20110608115430.32208.81891.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110608115430.32208.81891.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 08, 2011 at 02:54:30PM +0300, Kalle Valo wrote:
> Add testmode support for running low level hardware tests. The testmode
> is enabled by setting testmode module parameter to 1.
> 
> For now only a simple command passing is supported. More advanced
> support will be implemented later.
> 

It's Greg's call, but probably it's late in the release cycle to add
this feature.  Also are we even still developing this driver?  I
thought the real driver was moved to a different tree?

regards,
dan carpenter

