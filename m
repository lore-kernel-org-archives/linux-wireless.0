Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34781 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbbLMNYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2015 08:24:43 -0500
Received: by lfcy184 with SMTP id y184so31573393lfc.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Dec 2015 05:24:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449594545-31028-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449594545-31028-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Sun, 13 Dec 2015 15:24:42 +0200
Message-ID: <CANUX_P0Bhbb5__Xh2Bzp7gaxWQ3mG8e8XrH_ny2vR3PrTY5Qpg@mail.gmail.com> (sfid-20151213_142506_289690_3C8D3C54)
Subject: Re: [PATCH 1/2] mac80211: pass block ack session timeout to to driver
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sara Sharon <sara.sharon@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2015 at 7:09 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Sara Sharon <sara.sharon@intel.com>
>
> Currently mac80211 does not inform the driver of the session
> block ack timeout when starting a rx aggregation session.
> Drivers that manage the reorder buffer need to know this
> parameter.
> Seeing that there are now too many arguments for the
> drv_ampdu_action() function, wrap them inside a structure.
>
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---

Obviously we forgot to update the other drivers. Please drop this
series. Sara will re-send with the fix for the other drivers.
