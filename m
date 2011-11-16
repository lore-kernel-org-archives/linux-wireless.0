Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab1KPLPb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 06:15:31 -0500
Date: Wed, 16 Nov 2011 12:17:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
Message-ID: <20111116111702.GB2191@redhat.com> (sfid-20111116_121534_998928_8B758EC5)
References: <20111116100915.GA2191@redhat.com>
 <CAOZOX0WDQQeg4o5J9iQ_TpQgyYpTk5D3B4rpdTVR_4nGFVQ0wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOZOX0WDQQeg4o5J9iQ_TpQgyYpTk5D3B4rpdTVR_4nGFVQ0wg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:14:41AM +0100, Ivo Van Doorn wrote:
> > I changed rt2800pci only because get bug report for that device, not
> > sure if similar changes are not needed for other rt2x00 PCI devices.
> 
> The ticket mentiones that the end-result is a slow connection,
> this is also a bug in older chipsets. So could you prepare a patch
> for the other drivers as well?
Yes, sure. Do you have handy links to bug reports that I could
reference in the changelog?

Stanislaw
