Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:59969 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZHCXn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 19:43:57 -0400
Date: Tue, 4 Aug 2009 01:43:57 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nico@cam.org
Subject: Re: [PATCH 0/5] various mwl8k bugfixes
Message-ID: <20090803234357.GM18639@mail.wantstofly.org>
References: <20090803195816.GG18639@mail.wantstofly.org> <43e72e890908031329p7afcc94bg7d101a41041b46b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890908031329p7afcc94bg7d101a41041b46b2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 03, 2009 at 01:29:26PM -0700, Luis R. Rodriguez wrote:

> > This patch series fixes a couple of potential crashes and hangs in
> > mwl8k, and some other misbehaviour.  They are against current linus
> > tree, which is 2.6.31-rc5 plus some.  Please consider applying.
> 
> BTW mind adding a MAINTAINERS entry for this driver?

Will do in my next patchset.
