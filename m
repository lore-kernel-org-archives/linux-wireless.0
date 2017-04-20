Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53134 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S939310AbdDTEV0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 00:21:26 -0400
Message-ID: <1492662077.31741.89.camel@coelho.fi> (sfid-20170420_062959_260307_D60DB228)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Thu, 20 Apr 2017 07:21:17 +0300
In-Reply-To: <1492630450.31741.87.camel@coelho.fi>
References: <1492630450.31741.87.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2017-04-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-19 at 22:34 +0300, Luca Coelho wrote:
> Hi Kalle,
> 
> Here's my second pull-request intended for v4.12.  It includes the last
> two patch series I sent out, namely 2017-04-13 and 2017-04-19.
> 
> This pull request has a small difference from the patch sets I sent out,
> because I had to do a similar merge conflict resolution as you did.  Let
> me know if you want me to send v2 of those series to reflect these small
> changes (just for the record).
> 
> Kbuildbot didn't report any issues (before my conflict resolution).
> 
> Please let me know if there are any issues.

Please hold on with this pull.  Kbuildbot found an issue that was
introduced in my previous pull-req (the one you already pulled). 

Additionally, I want to remove the FW API bump to 31.

Sorry for the trouble.

--
Cheers,
Luca.
