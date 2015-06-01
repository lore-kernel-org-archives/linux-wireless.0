Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35212 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbFARHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 13:07:11 -0400
Received: by lbbuc2 with SMTP id uc2so88788580lbb.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 10:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <16916.1433173823@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
 <20150528154834.1259.22434.stgit@warthog.procyon.org.uk> <5567C131.8050005@kernel.org>
 <29091.1432903229@warthog.procyon.org.uk> <CALCETrUG7utqU7uKeC6q1rchBYL08V7peP1Ont95ZpBTiV7J9A@mail.gmail.com>
 <16916.1433173823@warthog.procyon.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 1 Jun 2015 10:06:49 -0700
Message-ID: <CALCETrX0kSAW4FvYKmZK8pVzi5XTJs3RtQxqYbyC_KTHeDhMjA@mail.gmail.com> (sfid-20150601_190718_276560_EF16B0F1)
Subject: Re: [PATCH 16/20] PKCS#7: Add an optional authenticated attribute to
 hold firmware name [ver #5]
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 1, 2015 at 8:50 AM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> > You can also fudge the signature (or a hash) by adding extra data to or
>> > modifying the data blob and by switching signature values between signature
>> > blobs.
>>
>> So there's another design error in PKCS#7?  Great!
>
> No.  This applies to *all* signatures where you're signing a hash.

What kind of fudging are you talking about here?  I don't see what
not-intentionally-signed message can be generically fudged to look
like it's signed.

--Andy
