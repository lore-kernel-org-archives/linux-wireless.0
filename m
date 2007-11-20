Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from there.is.no.cabal.ca ([134.117.69.58]:45665 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761661AbXKTXzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 18:55:01 -0500
Date: Tue, 20 Nov 2007 18:25:58 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: avoid oops when ah_capabilities.cap_mode not set
Message-ID: <20071120232558.GA8093@fattire.cabal.ca> (sfid-20071120_235512_659978_39A4975C)
References: <1192647780430-git-send-email-linville@tuxdriver.com> <43e72e890710171436s2e18a19ene70d3b058c835a96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890710171436s2e18a19ene70d3b058c835a96@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17, 2007 at 05:36:33PM -0400, Luis R. Rodriguez wrote:
> On 10/17/07, John W. Linville <linville@tuxdriver.com> wrote:
> > ah_capabilities.cap_mode doesn't get set for some cards, causing the
> > kernel to oops when these unknown/unsupported cards are inserted.
> > Add some NULL checks to avoid this.
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
> 

has this been dropped on the floor? I spotted it while going through
Fedora 7 kernel patches...

cheers,
	Kyle
