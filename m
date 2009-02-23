Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55077 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZBWNqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 08:46:36 -0500
Received: by bwz5 with SMTP id 5so4745707bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 05:46:34 -0800 (PST)
To: "Alina Friedrichsen" <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3] mac80211: Give it some time to do the TSF sync
References: <20090222171933.102390@gmx.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 23 Feb 2009 15:46:28 +0200
In-Reply-To: <20090222171933.102390@gmx.net> (Alina Friedrichsen's message of "Sun\, 22 Feb 2009 18\:19\:33 +0100")
Message-ID: <87mycd6zbf.fsf@litku.valot.fi> (sfid-20090223_144640_537015_C45F9003)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Alina Friedrichsen" <x-alina@gmx.net> writes:

> Give slow hardware some time to do the TSF sync, to not run into an
> IBSS merging endless loop in some rarely situations.
>
> Version 2 adds a comment.
> Version 3: I had forgotten to change the bracket.
> Version 4: No magic number.

Much better now, thanks. In the future, please write the patch
history...

> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---

... to here (ie after the '---' line) so that they are ignored when
the patch applied. This is easier for John.

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

Disclaimer: I know very little about mac80211 ibss implementation :)

-- 
Kalle Valo
