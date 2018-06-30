Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:43773 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932905AbeF3Ipn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 04:45:43 -0400
Message-ID: <fcce3f020bf507382ff25c8298fe799d8d3d47c3.camel@intel.com> (sfid-20180630_104548_006109_5A9444AD)
Subject: Re: [PATCH v2 0/4] iwlwifi: updates intended for v4.19 2018-06-26
From: Luciano Coelho <luciano.coelho@intel.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
        ilan.peer@intel.com, johannes@sipsolutions.net,
        liad.kaufman@intel.com, sara.sharon@intel.com,
        shaul.triebitz@intel.com
Date: Sat, 30 Jun 2018 11:45:39 +0300
In-Reply-To: <20180630084253.30660-1-luca@coelho.fi>
References: <20180630084253.30660-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-06-30 at 11:42 +0300, Luca Coelho wrote:
> Here's v2 of the patches I sent out Tuesday.  It fixes some
> bitfield.h
> warnings reported by kbuildbot in .../iwlwifi/fw/api/rx.h.
> 
> There is still one compiler warning in this series, but that's
> actually a bug in bitfield.h itself.  Johannes has sent a fix for
> that[1] but it has not been applied yet.

...and here's the reference to Johannes's patch I forgot to add:

[1] https://patchwork.kernel.org/patch/10465301/


--
Cheers,
Luca.
