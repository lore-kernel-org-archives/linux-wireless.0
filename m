Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56106 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbbEFHDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 03:03:42 -0400
Message-ID: <1430895798.2495.0.camel@sipsolutions.net> (sfid-20150506_090359_505525_D71D0A6D)
Subject: Re: [RFC v1 11/12] iwlwifi: use sysdata_file_request() and
 sysdata_file_request_async()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 06 May 2015 09:03:18 +0200
In-Reply-To: <1430873070-7290-12-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_031058_035930_55D8ED68)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
	 <1430873070-7290-12-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20150506_031058_035930_55D8ED68)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's the point in these conversions? You're clearly not converting
*all* users so you could get rid of request_firmware(), so this is
pretty much pointless.

johannes

