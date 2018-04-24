Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41342 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756587AbeDXK5A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 06:57:00 -0400
Message-ID: <995e264c12d5c982f05d4a71206dd2792c384ba6.camel@coelho.fi> (sfid-20180424_125703_409912_DAD6C3B3)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>
Date: Tue, 24 Apr 2018 13:56:57 +0300
In-Reply-To: <87d0ypos3l.fsf@codeaurora.org>
References: <20180422082745.9743-1-luca@coelho.fi>
         <20180422082745.9743-13-luca@coelho.fi> <87d0ypos3l.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 12/12] iwlwifi: mvm: set wakeup filters for wowlan "any"
 configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-04-24 at 12:45 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Eliad Peller <eliadx.peller@intel.com>
> > 
> > In can of "any" wowlan trigger is configured, no valid wakeup
> > filter
> > was configured.
> 
> "In case"?

Yeah, I'll fix it and resend.

--
Luca.
