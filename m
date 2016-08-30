Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41106 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751606AbcH3Iw2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 04:52:28 -0400
Message-ID: <1472547143.27868.73.camel@coelho.fi> (sfid-20160830_105232_652439_CEF7580E)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 30 Aug 2016 11:52:23 +0300
In-Reply-To: <1472505827.27868.41.camel@coelho.fi>
References: <1472505827.27868.41.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2016-08-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-08-30 at 00:23 +0300, Luca Coelho wrote:
> Hi Kalle,
> 
> Another pull request, this time intended for 4.9.  I have a lot of
> patches to send, but I'll send smaller batches this time. :)
> 
> These patches contain mostly preparation for new HW, but also some
> improvements in the dynamic queue allocation code and the
> implementation to support GMAC.
> 
> Let me know if everything's fine (or not). :)

Kalle,

The kbuild bot warning is valid.  I'll fix it and send a v2 of this
pull request, so please hold it back for now.

--
Cheers,
Luca.
