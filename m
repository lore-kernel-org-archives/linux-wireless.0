Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61608 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0BRBmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 20:42:06 -0500
Received: by pwj8 with SMTP id 8so1322970pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 17:42:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261432252-1855-7-git-send-email-8an@praha12.net>
References: <1261432252-1855-1-git-send-email-8an@praha12.net>
	<1261432252-1855-7-git-send-email-8an@praha12.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 17 Feb 2010 17:41:41 -0800
Message-ID: <43e72e891002171741w95a475ev3a81eac47c2d02e5@mail.gmail.com>
Subject: Re: [PATCH v3] iw: Add support for NL80211_ATTR_WIPHY_COVERAGE_CLASS
To: =?UTF-8?B?THVrw6HFoSBUdXJlaw==?= <8an@praha12.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2009 at 1:50 PM, Lukáš Turek <8an@praha12.net> wrote:
> New nl80211 attribute NL80211_ATTR_WIPHY_COVERAGE_CLASS allows setting
> IEEE 802.11 coverage class, which is then used by drivers to calculate
> slot time and ACK timeout for long distance links.
>
> Two iw parameters are added: 'coverage' sets the coverage class
> directly, while 'distance' is more user-friendly, as it allows to set
> just the link distance and let iw do the necessary calculation itself.
>
> Signed-off-by: Lukas Turek <8an@praha12.net>

This wasn't applied so going to resend rebasing with latest nl80211.h.

  Luis
