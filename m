Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:63206 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3A3T6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 14:58:19 -0500
Received: by mail-bk0-f43.google.com with SMTP id jm19so1020855bkc.30
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 11:58:17 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] iwl4965: report A-MPDU status
Date: Wed, 30 Jan 2013 20:58:13 +0100
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
References: <E1TzDQV-0001Fa-Sp@debian64.localnet> <20130128100857.GC2316@redhat.com> <20130130190703.GB2167@tuxdriver.com>
In-Reply-To: <20130130190703.GB2167@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301302058.13586.chunkeey@googlemail.com> (sfid-20130130_205823_528944_F005650E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, January 30, 2013 08:07:04 PM John W. Linville wrote:
> On Mon, Jan 28, 2013 at 11:08:58AM +0100, Stanislaw Gruszka wrote:
> > On Fri, Jan 18, 2013 at 11:47:19PM +0100, Christian Lamparter wrote:
> > > This patch is based on "iwlwifi: report A-MPDU status".
> > > (12bf6f45d1703858)
> > > 
> > > Since the firmware will give us an A-MPDU bit and
> > > only a single PHY information packet for all the
> > > subframes in an A-MPDU, we can easily report the
> > > minimal A-MPDU information for radiotap.
> > > 
> > > Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> > > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > 
> > ACK
> 
> OK, I'm confused...
Ah yes, maybe I can explain it.

> this ACK is for the patch posted on 18 Jan as
> "[PATCH 2/2] iwl4965: report A-MPDU status". 
> But on the next day (19 Jan) there was a patch
> posted as "[RFC ] iwl4965: report A-MPDU
> status" that seems to be different.  What a I
> missing?
Nothing I hope.

The patch "[PATCH 2/2] iwl4965: report A-MPDU status" might have
the date 2013-01-18, but it was sent on the 26th... A week after
the RFC. 

Note: The RFC is just both patches ("report A-MPDU status" and
"iwlegacy: fix antenna mask") merged into one. I did that because
I wanted to point out the issue of the *shared* bit (antenna mask
vs ampdu indicator). And thankfully, Johannes explained that... 
"the definition in question has always been the same for all
hardware. I just didn't fix it for 4965 since it was split off
to iwlegacy already."

Note2: I had to edit the patch "fix antenna mask" a second time,
that's why it has a newer date.

> Is this the right patch to merge?
Yes.

Best Regards,
	Christian
