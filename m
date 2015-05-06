Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbbEFQoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 12:44:08 -0400
Date: Wed, 6 May 2015 18:44:02 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 11/12] iwlwifi: use sysdata_file_request() and
 sysdata_file_request_async()
Message-ID: <20150506164402.GM5622@wotan.suse.de> (sfid-20150506_184430_016018_79B8299E)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-12-git-send-email-mcgrof@do-not-panic.com>
 <1430895798.2495.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430895798.2495.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 06, 2015 at 09:03:18AM +0200, Johannes Berg wrote:
> What's the point in these conversions? You're clearly not converting
> *all* users so you could get rid of request_firmware(), so this is
> pretty much pointless.

That is correct, as the cover letter stated these are just
examples of how one can use the new proposed extensible
API, the driver changes were just examples, it would
certainly be pointless and stupid to convert drivers
over.

  Luis
