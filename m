Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58070 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZKKOaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 09:30:16 -0500
Date: Wed, 11 Nov 2009 09:28:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Initialize rf302x RF values properly for
	rt2800pci.
Message-ID: <20091111142823.GC4392@tuxdriver.com>
References: <1257889360-388-1-git-send-email-gwingerde@gmail.com> <874op1efkk.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874op1efkk.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 08:33:15AM +0200, Kalle Valo wrote:
> Gertjan van Wingerde <gwingerde@gmail.com> writes:
> 
> > Ensure RF302x and RF2020 chipsets are handled properly in rt2800lib for the rt3090 chipset.
> >
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> Please line wrap commit logs. 72 characters or so per line is a good
> limit.

Yes, ACK.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
