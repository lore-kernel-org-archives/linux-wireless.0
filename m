Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36553 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbENPQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 11:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <9134.1431615745@warthog.procyon.org.uk>
References: <1431541436-17007-5-git-send-email-mcgrof@do-not-panic.com>
 <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
 <23142.1431615049@warthog.procyon.org.uk> <23172.1431615124@warthog.procyon.org.uk>
 <CAB=NE6WQoq-Es+rVsLgagGLxwzGJAMh2jy08Bf1wuy45xqwnmA@mail.gmail.com> <9134.1431615745@warthog.procyon.org.uk>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 14 May 2015 08:16:36 -0700
Message-ID: <CAB=NE6X8JMW7u-Ho4URjnsfM9=wKd14ZES+FCW_pf39y3qYSjg@mail.gmail.com> (sfid-20150514_171718_818319_B7DC436A)
Subject: Re: [RFC v2 4/6] scripts/sign-file.c: add support to only create
 signature file
To: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jlee@suse.com,
	Takashi Iwai <tiwai@suse.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2015 at 8:02 AM, David Howells <dhowells@redhat.com> wrote:
> I've got various Tested-by's on that.

Didn't know that would stop people from asking us from squashing them
but if so I'll try to use that some other time :)

> Anyway, I'm going to stack the attached patch on my branch if that's okay by
> you...

Sure thing. Let me know what you think about patch 2 and 5 as well, as
they might share similar fate.

  Luis
