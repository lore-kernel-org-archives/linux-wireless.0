Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:60829 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZIJRbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 13:31:33 -0400
Date: Thu, 10 Sep 2009 18:31:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-input@vger.kernel.org, linux-wireless@vger.kernel.org,
	marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20090910173127.GA8465@srcf.ucam.org>
References: <1252603292-20830-1-git-send-email-mjg@redhat.com> <43e72e890909101027saf1ed35u23936729eccf3f92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890909101027saf1ed35u23936729eccf3f92@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 10:27:01AM -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 10, 2009 at 10:21 AM, Matthew Garrett <mjg@redhat.com> wrote:
> 
> > This patch adds a new keycode, KEY_RFKILL_ALL.
> 
> >  include/linux/input.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> > +#define KEY_RFKILL             0x20c /* Key that controls all radios */
> 
> But this above is KEY_RFKILL, not KEY_RKILL_ALL. Typo?

Sorry, yes - forgot to update the commit message to match the change in 
the patch and subject.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
