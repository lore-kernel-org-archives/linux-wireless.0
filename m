Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbbENOwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 10:52:13 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <23142.1431615049@warthog.procyon.org.uk>
References: <23142.1431615049@warthog.procyon.org.uk> <1431541436-17007-5-git-send-email-mcgrof@do-not-panic.com> <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v2 4/6] scripts/sign-file.c: add support to only create signature file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 14 May 2015 15:52:04 +0100
Message-ID: <23172.1431615124@warthog.procyon.org.uk> (sfid-20150514_165217_025343_1CA9AECB)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> 
> > You can create a file.pkcs7 file with the -d option right now
> > but that still modifies the file. If all you want is the signature
> > file you can use -s now, that will leave the file passed as-is.
> 
> I would recommend you use something other than "-s" - that belongs to the code
> that is temporarily removed from the old perl script that allowed an external
> signature to be passed.

Use "-d".  I added the flag but then never made it do anything.

David
