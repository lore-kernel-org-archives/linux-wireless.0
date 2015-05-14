Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35083 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbbENOxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 10:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <23172.1431615124@warthog.procyon.org.uk>
References: <1431541436-17007-5-git-send-email-mcgrof@do-not-panic.com>
 <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
 <23142.1431615049@warthog.procyon.org.uk> <23172.1431615124@warthog.procyon.org.uk>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 14 May 2015 07:52:57 -0700
Message-ID: <CAB=NE6WQoq-Es+rVsLgagGLxwzGJAMh2jy08Bf1wuy45xqwnmA@mail.gmail.com> (sfid-20150514_165335_727406_D27B3F0D)
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

On Thu, May 14, 2015 at 7:52 AM, David Howells <dhowells@redhat.com> wrote:
> Use "-d".  I added the flag but then never made it do anything.

Sure, but since this C file is not upstream, how about just squashing
the commit with yours that adds the C file?

 Luis
