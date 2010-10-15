Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52345 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab0JOTi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 15:38:57 -0400
Date: Fri, 15 Oct 2010 12:20:29 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: compat-wireless question
Message-ID: <20101015192029.GA28742@kroah.com>
References: <E9954878DD1FB34FAE5187FB88C58A35012EE46BC3@orsmsx506.amr.corp.intel.com>
 <AANLkTi=6aVHyr98avc07UtWgDkV=SdmKW2HXNfSRY3KU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=6aVHyr98avc07UtWgDkV=SdmKW2HXNfSRY3KU@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 15, 2010 at 12:05:00PM -0700, Luis R. Rodriguez wrote:
> Furthermore, I realize that at times a vendor may have a patch that
> although it did not make it into the stable release of the kernel it
> may be important for the vendor for some customers, so because of this
> we have the linux-next-cherry-picks/ directory.

I'd be interested in taking these patches for -stable releases, if they
are in Linus's tree already, so feel free to forward them on to
stable@kernel.org if you get them.

thanks,

greg k-h
