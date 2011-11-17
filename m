Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1KQVL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:11:28 -0500
Subject: Re: 802.11p implementation...
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Jan de Jongh <jfcmdejongh@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAFtRNNxJjiCtPAyM=KwD+rpXkZXCUgpuSw2BHpaxb6frxBWumA@mail.gmail.com> (sfid-20111117_220842_818501_6C09A1EA)
References: <CAFtRNNwXdeBfa-mFNyAVALgTxM-wrUthgMLS18VokqOSSiWPqg@mail.gmail.com>
	 <1320585006.11133.2.camel@jlt3.sipsolutions.net>
	 <CAFtRNNxGd7NSmjNhZboW5VOZ++j=D1E_G6E6RqXLA3Ssuu4XfQ@mail.gmail.com>
	 <loom.20111112T202645-807@post.gmane.org>
	 <CAFtRNNxJjiCtPAyM=KwD+rpXkZXCUgpuSw2BHpaxb6frxBWumA@mail.gmail.com>
	 (sfid-20111117_220842_818501_6C09A1EA)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 22:11:25 +0100
Message-ID: <1321564285.3997.47.camel@jlt3.sipsolutions.net> (sfid-20111117_221132_114881_24C95346)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 22:59 +0200, Nick Kossifidis wrote:

> What else do you need from the driver and the protocol stack ? From a
> quick look at the patches you use, you only want half width channel
> support and to disable beacons by setting beacon interval to 0. Is
> that all ?

That, btw, is a complete hack and not an actual implementation of the
802.11p spec -- I don't think we'll want that upstream.

johannes

