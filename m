Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:33751 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbEFRbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 13:31:44 -0400
MIME-Version: 1.0
In-Reply-To: <17829.1430931479@warthog.procyon.org.uk>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-6-git-send-email-mcgrof@do-not-panic.com> <17829.1430931479@warthog.procyon.org.uk>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 6 May 2015 10:31:23 -0700
Message-ID: <CAB=NE6VJX=3jERjZRHn5dDxHsPtE9fya2ukxWfENxSObd0YQVQ@mail.gmail.com> (sfid-20150506_193201_016801_C550DF64)
Subject: Re: [RFC v1 05/12] firmware: add firmware signature checking support
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Ming Lei <ming.lei@canonical.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Kyle McMartin <kyle@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, jlee@suse.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 6, 2015 at 9:57 AM, David Howells <dhowells@redhat.com> wrote:
> I'm not sure how userspace actually passes the firmware blob to the kernel,
> but I do think that if you can, you should pass the signature separately to
> the blob.

Thanks yeah that is what I was hoping we'd prefer to end up doing.
Will look at your tree and see if I can base my work on that now.

 Luis
