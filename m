Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:3152 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYAFSTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 13:19:55 -0500
Received: by wa-out-1112.google.com with SMTP id v27so11974596wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 10:19:54 -0800 (PST)
Message-ID: <1ba2fa240801061019w2cc28082s9084c00a5d14f810@mail.gmail.com> (sfid-20080106_182006_754219_800106D5)
Date: Sun, 6 Jan 2008 20:19:54 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: Add radio led trigger
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801061410.12862.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200801061410.12862.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 6, 2008 3:10 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Some devices have a seperate LED which indicates if the radio is
> enabled or not. This adds a LED trigger to mac80211 where drivers
> can hook into when they are interested in radio status changes.
>
>
I wonder how this go together with RF KILL led?

Tomas
