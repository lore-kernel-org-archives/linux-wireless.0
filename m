Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50080 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023Ab1FVV0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 17:26:40 -0400
Received: by iwn6 with SMTP id 6so1041536iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 14:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308777866.29571.32.camel@jlt3.sipsolutions.net>
References: <1308777573-12257-1-git-send-email-arik@wizery.com> <1308777866.29571.32.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 23 Jun 2011 00:26:24 +0300
Message-ID: <BANLkTi=W_yPZ+tKY7Vquwsm4DdUrYZfG+A@mail.gmail.com> (sfid-20110622_232643_037591_0E5A797B)
Subject: Re: [PATCH 1/2] mac80211: propagate information about STA WME support down
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 23, 2011 at 00:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-06-23 at 00:19 +0300, Arik Nemtsov wrote:
>> Add a memeber to the ieee80211_sta structure to indicate whether the STA
>> supports WME.
>
>> + * @wme: indicates whether the STA supports WME
>
> You should probably update that also in other modes (when this is a
> station representing an AP) for consistency. If that's really tough you
> could document that it's only valid if the interface is in AP mode, but
> I guess I'd prefer just having it valid.

Sure I'll take a look. It'll take a couple of days though.

Arik
