Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:16589 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab0KJLVz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 06:21:55 -0500
Subject: Re: [PATCH 2/2] Revert "wl1271: Change supported channel order for
 a more optimal scan"
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "geryk@ti.com" <geryk@ti.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDA7F7A.4000705@ti.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1289384840-28305-2-git-send-email-juuso.oikarinen@nokia.com>
	 <4CDA7F7A.4000705@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 13:21:26 +0200
Message-ID: <1289388086.2522.72.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 12:18 +0100, ext Gery Kahn wrote:
> On 11/10/2010 12:27 PM, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> >
> > This reverts commit fa21c7a9e4be439e217fe72edbd39b643b643791.
> >
> > The reverted patch caused more harm than benefit.
> >
> > Signed-off-by: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> >
> Just couple words what harm it was?

The harm is that the supported channels are reported to user-space in
the order they are registered in the driver. The result of that is quite
messy in userspace PoV.

-Juuso

