Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:38559 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2LMV4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:56:38 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2236231lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 13:56:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-18-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-18-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 13:56:16 -0800
Message-ID: <CAB=NE6Xv0p_zBU81y+10tSvVZVxVjLuADBxj+FO3uxBptsNYzw@mail.gmail.com> (sfid-20121213_225640_661416_1163248B)
Subject: Re: [PATCH 17/24] regulatory: remove locking from wiphy_apply_custom_regulatory
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> wiphy_apply_custom_regulatory() doesn't have to hold
> the regulatory mutex as it only modifies the given
> wiphy with the given regulatory domain, it doesn't
> access any global regulatory data.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
