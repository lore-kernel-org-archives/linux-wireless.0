Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52997 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbZLNOAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 09:00:21 -0500
Date: Mon, 14 Dec 2009 08:54:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: support internal statically compiled
	regulatory database
Message-ID: <20091214135401.GB18945@tuxdriver.com>
References: <1260755116-3829-1-git-send-email-linville@tuxdriver.com> <1260755719.4041.1.camel@localhost.localdomain> <20091214032920.GB4743@tuxdriver.com> <1260777312.4041.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1260777312.4041.13.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2009 at 08:55:12AM +0100, Marcel Holtmann wrote:

> > > since it is pretty clear that people should be defaulting to CRDA, why
> > > not make it depend on CONFIG_EMBEDDED.

<snip>

> So my personal view on this is that it is an embedded feature and not
> something for the general wireless people. My 2 cents.

Yeah, that's a fine suggestion.  I'll do that before merging it.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
