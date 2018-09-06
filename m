Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:56304 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbeIFLN0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 07:13:26 -0400
Message-ID: <1536215959.4015.1.camel@sipsolutions.net> (sfid-20180906_083933_891728_FCEB0A16)
Subject: Re: [PATCH v2 2/3] mac80211: support FTM responder
 configuration/statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date: Thu, 06 Sep 2018 08:39:19 +0200
In-Reply-To: <f6cb4548de9c5ca228124df1301d2aa0@codeaurora.org>
References: <1535745418-31336-1-git-send-email-pradeepc@codeaurora.org>
         <1535745418-31336-3-git-send-email-pradeepc@codeaurora.org>
         <1535967225.3437.27.camel@sipsolutions.net>
         <f6cb4548de9c5ca228124df1301d2aa0@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Perhaps the *existence* of ftmr_params could indicate that it's 
> > enabled?
> 
> My understanding is these are only optional parameters. So, I have kept 
> ftm_responder separate from params.

Yes, they're only optional. I was just thinking that even an "empty" set
of parameters could indicate enablement, but I guess we can even avoid
the memory allocation, so perhaps it's better this way. Anyway it's only
an internal API so can change as needed.

johannes
