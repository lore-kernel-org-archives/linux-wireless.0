Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48844 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZLOVlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:41:25 -0500
Date: Tue, 15 Dec 2009 16:30:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>, stable@kernel.org
Subject: Re: [PATCH v2 2.6.33] rt2x00: Disable powersaving for rt61pci and
	rt2800pci.
Message-ID: <20091215213052.GF8735@tuxdriver.com>
References: <1260819235-8017-1-git-send-email-gwingerde@gmail.com> <20091215204432.GE8735@tuxdriver.com> <14add3d10912151310s6b36cc60vabbdac4afff2e4b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <14add3d10912151310s6b36cc60vabbdac4afff2e4b4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 10:10:19PM +0100, Gertjan van Wingerde wrote:
> On Tue, Dec 15, 2009 at 9:44 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Mon, Dec 14, 2009 at 08:33:55PM +0100, Gertjan van Wingerde wrote:
> >> We've had many reports of rt61pci failures with powersaving enabled.
> >> Therefore, as a stop-gap measure, disable powersaving of the rt61pci
> >> until we have found a proper solution.
> >> Also disable powersaving on rt2800pci as it most probably will show
> >> the same problem.
> >>
> >> Cc: stable@kernel.org
> >> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> >> ---
> >>
> >> John, this is an urgent fix for 2.6.33.
> >>
> >> v2:
> >> - Handled feedback from Ivo:
> >>       - Only disable powersaving by default, not permanent.
> >>       - Also apply to rt2800pci.
> >
> > As posted, it will only compile on 2.6.32...
> >
> 
> Me confused, as the patch was against the wireless-2.6.git tree, which
> I thought was 2.6.33, and not 2.6.32. Please explain to which tree to
> prepare fixes for 2.6.33.

That seems rather impossible, since wireless-2.6 failed to build with
your patch applied. :-)  Perhaps you weren't up-to-date?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
