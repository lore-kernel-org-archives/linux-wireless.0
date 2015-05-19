Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbbESJeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 05:34:22 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
References: <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com> <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [RFC v3 2/2] firmware: add firmware signature checking support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 19 May 2015 10:33:45 +0100
Message-ID: <9026.1432028025@warthog.procyon.org.uk> (sfid-20150519_113500_472996_FB09C06C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> +		-nocerts -md $DIGEST_ALGORITHM -binary > \
> +		$(FIRMWARE_BLOB_NAME).p7s

Rather than using '>' it might be worth using '-out' instead.

David
