Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60824 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZBISpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 13:45:53 -0500
Date: Mon, 9 Feb 2009 13:39:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tony Vroon <tony@linx.net>
Cc: linux-wireless@vger.kernel.org,
	reinette chatre <reinette.chatre@intel.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
Message-ID: <20090209183924.GA6069@tuxdriver.com> (sfid-20090209_194558_884022_ECA1E29B)
References: <1234202993.21570.18.camel@localhost> <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com> <1234203811.21570.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234203811.21570.19.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2009 at 06:23:31PM +0000, Tony Vroon wrote:
> On Mon, 2009-02-09 at 10:20 -0800, Luis R. Rodriguez wrote:
> > Your AP did not provide 5 GHz frequencies in its country information
> > element. Because of this the intersection between what CRDA has for GB
> > and what your AP provides does not include any channels in 5 GHz. This
> > has been fixed in wireless-testing though, if your AP country IE does
> > not have information for a separate band we lave that band to trust
> > CRDA information instead.
> > 
> > This should have been propagated down to 29 already, maybe it'll be in
> > rc5?
> 
> John, will this make it into 2.6.29 final please?

It is in 2.6.29-rc3 AFAICT.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
