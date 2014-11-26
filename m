Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60798 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaKZLC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 06:02:59 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so3356787wgg.36
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 03:02:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125193846.GJ25677@wotan.suse.de>
References: <1416754941-4439-1-git-send-email-arik@wizery.com> <20141125193846.GJ25677@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Nov 2014 13:02:42 +0200
Message-ID: <CA+XVXfd2fGK04i3XCH1ng5rYP2VgBamCZhJL_ibwNbsStpPBvA@mail.gmail.com> (sfid-20141126_120302_752944_4CBD99BB)
Subject: Re: [PATCH v3 1/3] cfg80211: leave invalid channels on regdomain change
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 9:38 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>
> Please rename to REGULATORY_IGNORE_STALE_KICKOFF, also please add
> some information about the amount current of grace period used,
> and types of interfaces supported. Since this is a regulatory flag
> this information will help folks decide whether to enable or not.
> Also encourage its use, and mention that once all supported devices
> get support for this will be enabled by default. In the meantime
> I'd prefer if this feature was enabled by default if the supported
> interface types of a dveice match the white list of supported
> interfaces.

Will do.

Arik
