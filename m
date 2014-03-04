Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46907 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbaCDUPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 15:15:17 -0500
Date: Tue, 4 Mar 2014 15:13:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Fariya Fatima <fariya.f@redpinesignals.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3.14.0-rc5 v3 1/10] rsi: Adding RS9113 driver files
Message-ID: <20140304201313.GI7317@tuxdriver.com> (sfid-20140304_211527_575942_EB64E6B4)
References: <5314357A.8090205@redpinesignals.com>
 <20140304183828.GD7317@tuxdriver.com>
 <CAOiHx==y9aSLA+Whr9A1xo7ikp7pDMtotc7=gPPZfPNLjap8rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOiHx==y9aSLA+Whr9A1xo7ikp7pDMtotc7=gPPZfPNLjap8rA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 04, 2014 at 09:08:26PM +0100, Jonas Gorski wrote:
> On Tue, Mar 4, 2014 at 7:38 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > Does anyone have any last objections or criticisms to this patch series?
> 
> > On Mon, Mar 03, 2014 at 01:25:38PM +0530, Fariya Fatima wrote:
> >> Kconfig               |    1
> >> Makefile              |    1
> 
> A minor critique would be that these Kconfig/Makefile changes should
> be added in the last patch, else any in-between will result in a state
> where the driver is selectable, but fails to build because of missing
> source files.

FWIW, I tend to collapse a series like this (i.e. one that adds a new
driver using a series of small, non-buildable patches) into a single
patch when merging.

> Also the subject suggests the patch set was based on linus' tree, not
> wireless-next (or whatever the correct tree is), but this does not
> necessarily mean it does not apply; I did not test this.

This is usually not a (big) merge problem for a new driver.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
