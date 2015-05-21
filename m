Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422635AbbEUQYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:24:22 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150520154755.GE126473@ubuntu-hedt>
References: <20150520154755.GE126473@ubuntu-hedt> <20150520140426.GB126473@ubuntu-hedt> <20150519200232.GM23057@wotan.suse.de> <6731.1432134538@warthog.procyon.org.uk>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: dhowells@redhat.com, "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 21 May 2015 17:23:54 +0100
Message-ID: <10137.1432225434@warthog.procyon.org.uk> (sfid-20150521_182441_954238_48EE14D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seth Forshee <seth.forshee@canonical.com> wrote:

> > Relying on UEFI presents three problems, though: (1) the system admin has to
> > manually, as far as I'm aware, inform the BIOS; (2) the UEFI storage is
> > limited; and (3) not all systems have UEFI.
> 
> Yeah, that doesn't really sound like a good solution. Not all users are
> sys admins.

Yeah.  We don't really want to recommend they go meddling lest they brick
their machine by triggering a bug in their BIOS.  Not that there *are* any
buggy BIOSes of course;-)

David
