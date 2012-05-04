Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44682 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287Ab2EDIsv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 04:48:51 -0400
Received: by lahj13 with SMTP id j13so1847260lah.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 May 2012 01:48:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336071691.5167.10.camel@jlt3.sipsolutions.net>
References: <1335266308-3286-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<1336071691.5167.10.camel@jlt3.sipsolutions.net>
Date: Fri, 4 May 2012 11:48:48 +0300
Message-ID: <CAMXE1-p6KcFA8_8ZXOOUANjmpnUiJ7ZBqRHM2rqJK-TLvDr7Yw@mail.gmail.com> (sfid-20120504_104855_333416_4825AF32)
Subject: Re: [PATCH] mac80211: Adds clean sdata helper
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, May 3, 2012 at 10:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Looks fine to me, but I'd prefer not having the mesh.h change, maybe we
> can add an extra  if (ieee80211_vif_is_mesh(&sdata->vif)) or use if
> instead of switch?

Is this approach a recommended way? Otherwise using "elseif" or "if"
inside "switch" looks somehow not OK.

Regards,
Andrei
