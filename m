Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47010 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZBPQA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 11:00:57 -0500
Date: Mon, 16 Feb 2009 10:47:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tony Vroon <tony@linx.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
Message-ID: <20090216154733.GA2870@tuxdriver.com> (sfid-20090216_170100_497595_3C0F9A59)
References: <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com> <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost> <20090210013941.GA4386@tesla> <1234230689.3793.15.camel@localhost> <20090210020708.GC4386@tesla> <1234379981.4789.7.camel@localhost> <20090214045232.GA5769@tesla> <1234786124.4271.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234786124.4271.2.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 12:08:44PM +0000, Tony Vroon wrote:
> Just to confirm, if I use my early-boot hook that I used for your iw
> list to set the regulatory domain manually (iw reg set GB) all is well.
> If I allow the driver stack to get to the association stage without
> setting a regulatory domain, I can never get my 802.11A spectrum back
> after the fact.
> Would you still see this as a bug or rather a specific requirement of
> the new interface that hasn't yet been documented?

Seems like a bug, or at least an unintended consequence of intersection...?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
