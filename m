Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3KTNO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 08:14:58 -0500
Date: Wed, 20 Nov 2013 15:12:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: users@rt2x00.serialmonkey.com,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 3.12] rt2800usb: slow down TX statuspolling
Message-ID: <20131120141227.GA3827@redhat.com> (sfid-20131120_141501_618593_972DD14C)
References: <20131017100431.GA9603@redhat.com>
 <20131018094238.GA7506@redhat.com>
 <526243C2.7090607@gmail.com>
 <1413247.TRgdXSqTuO@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413247.TRgdXSqTuO@fb07-iapwap2>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 01:53:29PM +0100, Marc Dietrich wrote:
> > > Resolve:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=62781
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > 
> > I don't care which version gets picked. In both cases:
> > 
> > Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> did this ever hit a stable queue? 

Not yet, it lend now in Linus' tree, should be queued to stable soon.

Stanislaw
