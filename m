Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51970 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZI3Raz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 13:30:55 -0400
Date: Wed, 30 Sep 2009 13:23:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Matt Tierney <matt.tierney@post.harvard.edu>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Possible to set MCS Index?
Message-ID: <20090930172306.GA6364@tuxdriver.com>
References: <d355d36c0909300814w302f11a4rb5b23a80aee36c43@mail.gmail.com> <20090930164853.GA5730@mosca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090930164853.GA5730@mosca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 09:48:53AM -0700, Luis R. Rodriguez wrote:

> A good step would be to get ath9k rate control to be switchable
> to minstrel, for example. This can be done as a module parameter
> to start but eventually I think it'd be nice to be able to switch
> through iw on any given device. That would require quite a lot of
> work though.

ACK to the above...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
