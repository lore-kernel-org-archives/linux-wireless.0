Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:57006 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0AOAxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 19:53:11 -0500
Received: by pzk1 with SMTP id 1so287734pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 16:53:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263516497-17332-1-git-send-email-benoit.papillault@free.fr>
References: <1263516497-17332-1-git-send-email-benoit.papillault@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Jan 2010 16:52:49 -0800
Message-ID: <43e72e891001141652h6830c395ufea7602c009292f2@mail.gmail.com>
Subject: Re: [PATCH] mac80211: check that ieee80211_set_power_mgmt only
	handles STA interfaces.
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 14, 2010 at 4:48 PM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> ieee80211_set_power_mgmt is meant for STA interfaces only. Moreover,
> since sdata->u.mgd.mtx is only initialized for STA interfaces, using
> this code for any other type of interface (like IBSS) will result in a
> oops.

Is this path even possible at this point? Is this a stable fix?

  Luis
