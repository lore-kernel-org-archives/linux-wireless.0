Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbbESQXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 12:23:40 -0400
Date: Tue, 19 May 2015 18:23:35 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [RFC v3 2/2] firmware: add firmware signature checking support
Message-ID: <20150519162335.GD23057@wotan.suse.de> (sfid-20150519_182358_302943_DCD34645)
References: <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
 <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
 <9026.1432028025@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9026.1432028025@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 10:33:45AM +0100, David Howells wrote:
> Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> 
> > +		-nocerts -md $DIGEST_ALGORITHM -binary > \
> > +		$(FIRMWARE_BLOB_NAME).p7s
> 
> Rather than using '>' it might be worth using '-out' instead.

Sure, will amend.

  Luis
