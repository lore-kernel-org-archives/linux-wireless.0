Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:44636 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751309AbdHaV5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 17:57:49 -0400
Message-ID: <1504216665.2786.48.camel@perches.com> (sfid-20170831_235752_629839_DC0F6B85)
Subject: Re: [PATCH 1/2] iwlwifi: fix long debug print
From: Joe Perches <joe@perches.com>
To: Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 31 Aug 2017 14:57:45 -0700
In-Reply-To: <20170825082730.31388-2-luca@coelho.fi>
References: <20170825082730.31388-1-luca@coelho.fi>
         <20170825082730.31388-2-luca@coelho.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-08-25 at 11:27 +0300, Luca Coelho wrote:
> From: Liad Kaufman <liad.kaufman@intel.com>
> 
> There is a debug print that sometimes reaches over
> 110 chars, thus generating a warning in those cases.

What emits a warning here?
