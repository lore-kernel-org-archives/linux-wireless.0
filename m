Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55661 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbZBQSnR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 13:43:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 10:43:17 -0800
Date: Tue, 17 Feb 2009 10:42:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Tony Vroon <tony@linx.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
Message-ID: <20090217184230.GA4257@tesla> (sfid-20090217_194321_995904_D41CD3D3)
References: <20090209183924.GA6069@tuxdriver.com> <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost> <20090210013941.GA4386@tesla> <1234230689.3793.15.camel@localhost> <20090210020708.GC4386@tesla> <1234379981.4789.7.camel@localhost> <20090214045232.GA5769@tesla> <1234786124.4271.2.camel@localhost> <20090216154733.GA2870@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090216154733.GA2870@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 07:47:33AM -0800, John W. Linville wrote:
> On Mon, Feb 16, 2009 at 12:08:44PM +0000, Tony Vroon wrote:
> > Just to confirm, if I use my early-boot hook that I used for your iw
> > list to set the regulatory domain manually (iw reg set GB) all is well.
> > If I allow the driver stack to get to the association stage without
> > setting a regulatory domain, I can never get my 802.11A spectrum back
> > after the fact.
> > Would you still see this as a bug or rather a specific requirement of
> > the new interface that hasn't yet been documented?
> 
> Seems like a bug, or at least an unintended consequence of intersection...?


