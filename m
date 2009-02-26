Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:44313 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbZBZQjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 11:39:48 -0500
Received: by ey-out-2122.google.com with SMTP id 25so172817eya.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2009 08:39:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
References: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
Date: Thu, 26 Feb 2009 08:39:44 -0800
Message-ID: <43e72e890902260839n6e542652i31dc8652dc007720@mail.gmail.com> (sfid-20090226_173951_826909_C062472B)
Subject: Re: [PATCH 0/3] cfg80211: send regulatory events to userspace
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2009 at 6:39 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This series does the work to prep and then send regulatory
> events to userspace. Userspace can now know if its requests
> were applied or not and when.
>
> This applies on top of Jouni's MLME patch for cfg80211.

Will send a v2, noticed I forgot to remove the country ie env from
nl80211.h as we don't need it. My initial though was to also send the
country IE checksum and env but that is just pointless as users can
already get the regulatory domain through 'iw reg get'. Will also need
to update the documentation based on this.

  Luis
