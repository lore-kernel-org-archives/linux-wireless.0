Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab2A3UWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 15:22:37 -0500
Message-ID: <1327955014.20937.2.camel@dcbw.foobar.com> (sfid-20120130_212248_882821_DB10752C)
Subject: Re: MAINTAINER NEEDED -- Re: status of ipw2x00
From: Dan Williams <dcbw@redhat.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tom Gundersen <teg@jklm.no>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 30 Jan 2012 14:23:34 -0600
In-Reply-To: <201201302113.26344.florian@openwrt.org>
References: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com>
	 <20120130184446.GB2493@tuxdriver.com>
	 <1327953315.1789.23.camel@dcbw.foobar.com>
	 <201201302113.26344.florian@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 21:13 +0100, Florian Fainelli wrote:
> On Monday 30 January 2012 20:55:15 Dan Williams wrote:
> > On Mon, 2012-01-30 at 13:44 -0500, John W. Linville wrote:
> > > On Mon, Jan 30, 2012 at 02:42:52PM +0100, Tom Gundersen wrote:
> > > > If we are not able to drop the 2x00 drivers, are anyone still
> > > > interested in working on them to fix the firmware loading?
> > > 
> > > Anyone out there looking for a project?  A way to "break-in" to the
> > > public Linux community without the risk of breaking anything too
> > > important? :-)
> > > 
> > > If someone wants to be the ipw2x00 maintainer, all they need to do
> > > is start sending some non-broken patches...
> > 
> > I'd be willing to donate an ipw2200 to somebody who steps up to maintain
> > the driver.  I'll even consider paying postage.  Note that you'll need
> > to have a machine with a MiniPCI slot, or a desktop machine with PCI and
> > a PCI->MiniPCI adapter card.
> 
> I can also send a mini-pci ipw2200-based board to anyone interested. Hint: 
> having two cards is also convenient.

I'll raise you a 2915 (which is the 802.11a capable part that also uses
the ipw2200 driver) if the person who steps up is really motivated :)

Dan

