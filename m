Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:45855 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbYA2WnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 17:43:05 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3894121wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2008 14:43:04 -0800 (PST)
Message-ID: <1ba2fa240801291443r6a71a1d6tcf78e9197f8abfed@mail.gmail.com> (sfid-20080129_224318_588033_5806BA7B)
Date: Wed, 30 Jan 2008 00:43:04 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] iwlwifi: enable 802.11n in Kconfig
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1201623341.4394.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12014391833639-git-send-email-tomas.winkler@intel.com>
	 <1201623341.4394.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 29, 2008 6:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Sun, 2008-01-27 at 15:06 +0200, Tomas Winkler wrote:
> > This patch removes 'IWL4965_HT: depends on n'  from iwlwifi's Kconfig
> > 1. 11n is functional so no need to make it invisible in the configuration
> > 2. Latest Johannes patch 'cfg80211 API for channels/bitrates, mac80211 and
> > driver conversion' broke compilation because this config option was
> > invisible - patch fixing it will be provided later
>
> Hah, and I actually had found code that I knew was going to break but
> since I couldn't enable it I ignored it. I didn't know it was already
> functional, I would have enabled it if I'd known.
>
Understood,
The whole mandatory part of 11n, meaning RX is already in so we can
safely enabled it.Even in 2.6.25

Hope the TX part will follow.
Thanks

> johannes
>
