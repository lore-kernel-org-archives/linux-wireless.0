Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36760 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753976AbdAZRaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 12:30:05 -0500
Message-ID: <1485449523.26003.4.camel@coelho.fi> (sfid-20170126_183009_605218_F3808AF9)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Thu, 26 Jan 2017 18:52:03 +0200
In-Reply-To: <20170126162003.31531-1-johannes@sipsolutions.net>
References: <20170126162003.31531-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] wireless: define cipher/AKM suites using a macro
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-26 at 17:20 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The spec writes cipher/AKM suites as something like 00-0F-AC:9,
> but the part after the colon isn't hex, it's decimal, so that
> we've already had a few mistakes (in other code, or unmerged
> patches) to e.g. write 0x000FAC10 instead of 0x000FAC0A.
> 
> Use a macro to avoid that problem.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Reviewed-by: Luca Coelho <luciano.coelho@intel.com>

--
Luca.
