Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZJPP1g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 11:27:36 -0400
Date: Fri, 16 Oct 2009 08:23:43 -0700
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/stlc45xx: Fix compile error
Message-ID: <20091016152343.GB24018@kroah.com>
References: <1255575825.10636.17.camel@laptop>
 <20091015031138.GB16633@kroah.com>
 <87zl7rbyl2.fsf@nokia.com>
 <390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 10:11:22AM -0400, Javier Martinez Canillas wrote:
> If you agree I could take the task to mantain stlc45xx. I have the
> time, the motivation and I think the skills to do it.
> 
> At least I could make it compile when the API changes and work on bugs
> reported until you are confident that p54spi driver is good enough and
> there is no need anymore for stlc45xx.

Great, care to send me a patch adding a TODO file for this driver so
that we can keep the info straight?

thanks,

greg k-h
