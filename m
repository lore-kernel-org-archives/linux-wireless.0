Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:65370 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZIXJqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 05:46:35 -0400
Received: by iwn8 with SMTP id 8so803215iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 02:46:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253775657.3868.8.camel@johannes.local>
References: <1253775657.3868.8.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 02:46:19 -0700
Message-ID: <43e72e890909240246t1f0377d8h350565d1679703c@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: don't set privacy w/o key
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 12:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> When wpa_supplicant is used to connect to open networks,
> it causes the wdev->wext.keys to point to key memory, but
> that key memory is all empty. Only use privacy when there
> is a default key to be used.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
