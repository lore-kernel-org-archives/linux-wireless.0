Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50177 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbaGURAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 13:00:14 -0400
Date: Mon, 21 Jul 2014 12:45:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] wlcore: add basic device-tree support
Message-ID: <20140721164505.GD9026@tuxdriver.com> (sfid-20140721_190052_347266_C56D40BD)
References: <1404898305-15588-1-git-send-email-eliad@wizery.com>
 <CAGm1_kvTYiDZDuFrB9X1ZOCxrhPC_NE_UzzY8PoBpdZHrQgv_A@mail.gmail.com>
 <CAB3XZEeC8AeAw03Va6WZ_WHwy6YABkSjg0BMdf=6gGu1UyncSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB3XZEeC8AeAw03Va6WZ_WHwy6YABkSjg0BMdf=6gGu1UyncSA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 09, 2014 at 02:45:33PM +0300, Eliad Peller wrote:
> On Wed, Jul 9, 2014 at 2:00 PM, Yegor Yefremov
> <yegorslists@googlemail.com> wrote:
> > On Wed, Jul 9, 2014 at 11:31 AM, Eliad Peller <eliad@wizery.com> wrote:
> >> When running with device-tree, we no longer have a board file
> >> that can set up the platform data for wlcore.
> >> Allow this data to be passed from DT.
> >>
> >> For now, parse only the irq used. Other (optional) properties
> >> can be added later on.
> >
> > What about adding support for "mac-address"
> > (Documentation/devicetree/bindings/net/ethernet.txt) node or will it
> > be automatically available?
> >
> the mac address is currently either read from the device itself or
> from the nvs (calibration) file.
> i guess additional support for such dt properties can be added later
> on, if needed.

Ok with the device tree folks?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
