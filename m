Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36760 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3JaMxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 08:53:53 -0400
Received: by mail-pa0-f47.google.com with SMTP id lf10so2442180pab.20
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 05:53:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131030184302.GA1026@localhost>
References: <1383152974-13097-1-git-send-email-arik@wizery.com> <20131030184302.GA1026@localhost>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 31 Oct 2013 14:53:38 +0200
Message-ID: <CA+XVXfehC87=3oZT=Rn=4P50QrfPx027LiefUF4nwoHg7hm_4w@mail.gmail.com> (sfid-20131031_135405_752881_E2244B7D)
Subject: Re: [PATCH] nl80211: better document NL80211_CMD_TDLS_MGMT
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 30, 2013 at 8:43 PM, Bob Copeland <me@bobcopeland.com> wrote:
>
> On Wed, Oct 30, 2013 at 07:09:34PM +0200, Arik Nemtsov wrote:
> > + * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame. The
> > + *   %NL80211_ATTR_TDLS_ACTION attribute determines the typ of frame to be
>
> type typo there.

Thanks.
