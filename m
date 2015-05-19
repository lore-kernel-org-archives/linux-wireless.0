Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34332 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbESUlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 16:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <20150519200232.GM23057@wotan.suse.de>
References: <20150519200232.GM23057@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 19 May 2015 13:40:38 -0700
Message-ID: <CAB=NE6UQOxaRHbN0-mGHjqwyQWoogudWUP-WO-DC6k6iRhVsUA@mail.gmail.com> (sfid-20150519_224119_512379_8C7A3004)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
To: linux-security-module <linux-security-module@vger.kernel.org>,
	James Morris <james.l.morris@oracle.com>, serge@hallyn.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, Konstantin Ryabitsev <mricon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 1:02 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> Other than this last nitpick, any other concerns or recommendations ?

Oh one more thing. I think we should decide on a digest algorithm we'd
wish to be used for linux-firmware signing, distributions likely will
want to just have this enabled =y in their kernel unless of course
proper care is taken to also make sure such module is available early
for initramfs uses. The digest algorithm can be different than what
any distribution uses for their own module signing digest.

 Luis
