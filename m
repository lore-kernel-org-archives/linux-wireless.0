Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbbFAPud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 11:50:33 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALCETrUG7utqU7uKeC6q1rchBYL08V7peP1Ont95ZpBTiV7J9A@mail.gmail.com>
References: <CALCETrUG7utqU7uKeC6q1rchBYL08V7peP1Ont95ZpBTiV7J9A@mail.gmail.com> <20150528154605.1259.42518.stgit@warthog.procyon.org.uk> <20150528154834.1259.22434.stgit@warthog.procyon.org.uk> <5567C131.8050005@kernel.org> <29091.1432903229@warthog.procyon.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>,
	Luis Rodriguez <mcgrof@suse.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, keyrings@linux-nfs.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kyle McMartin <kyle@kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	Mimi Zohar <zohar@us.ibm.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 16/20] PKCS#7: Add an optional authenticated attribute to hold firmware name [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 01 Jun 2015 16:50:23 +0100
Message-ID: <16916.1433173823@warthog.procyon.org.uk> (sfid-20150601_175114_847838_05FAA82A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Lutomirski <luto@amacapital.net> wrote:

> > You can also fudge the signature (or a hash) by adding extra data to or
> > modifying the data blob and by switching signature values between signature
> > blobs.
> 
> So there's another design error in PKCS#7?  Great!

No.  This applies to *all* signatures where you're signing a hash.

David
