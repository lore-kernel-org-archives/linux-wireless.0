Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63595 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaEOLhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 07:37:18 -0400
Received: by mail-lb0-f180.google.com with SMTP id p9so673145lbv.39
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 04:37:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400148339-10006-1-git-send-email-luca@coelho.fi>
References: <1400148339-10006-1-git-send-email-luca@coelho.fi>
Date: Thu, 15 May 2014 13:37:16 +0200
Message-ID: <CALhHN=pNMXpEhTur2zH15_8ZptTrM9WGkE6fJ7-EXvM_3_bQNw@mail.gmail.com> (sfid-20140515_133722_765569_9B770E09)
Subject: Re: [PATCH] cfg80211: pass the actual iftype when calling cfg80211_chandef_dfs_required()
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, eliad@wizery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 May 2014 12:05, Luca Coelho <luca@coelho.fi> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> There is no need to pass NL80211_IFTYPE_UNSPECIFIED when calling
> cfg80211_chandef_dfs_required() since we always already have the
> interface type.  So, pass the actual interface type instead.
>
> Additionally, have cfg80211_chandef_dfs_required() WARN if the passed
> interface type is NL80211_IFTYPE_UNSPECIFIED, so we can detect
> problems more easily.
>
> Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> Reported-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>

Tested-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, works fine.

BR
Janusz
