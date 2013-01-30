Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50538 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3A3TPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 14:15:24 -0500
Date: Wed, 30 Jan 2013 14:07:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] iwl4965: report A-MPDU status
Message-ID: <20130130190703.GB2167@tuxdriver.com> (sfid-20130130_201528_596568_169359E5)
References: <E1TzDQV-0001Fa-Sp@debian64.localnet>
 <20130128100857.GC2316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130128100857.GC2316@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2013 at 11:08:58AM +0100, Stanislaw Gruszka wrote:
> On Fri, Jan 18, 2013 at 11:47:19PM +0100, Christian Lamparter wrote:
> > This patch is based on "iwlwifi: report A-MPDU status".
> > (12bf6f45d1703858)
> > 
> > Since the firmware will give us an A-MPDU bit and
> > only a single PHY information packet for all the
> > subframes in an A-MPDU, we can easily report the
> > minimal A-MPDU information for radiotap.
> > 
> > Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> 
> ACK

OK, I'm confused...this ACK is for the patch posted on 18 Jan as
"[PATCH 2/2] iwl4965: report A-MPDU status".  But on the next day
(19 Jan) there was a patch posted as "[RFC ] iwl4965: report A-MPDU
status" that seems to be different.  What a I missing?  Is this the
right patch to merge?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
