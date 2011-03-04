Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16191 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1CDPUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 10:20:07 -0500
Subject: Re: 2.6.38-rc7, iwlagn crash
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110304134648.GB9866@tuxdriver.com>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	 <20110304134648.GB9866@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 07:17:59 -0800
Message-ID: <1299251879.24333.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 05:46 -0800, John W. Linville wrote:
> Cc'ing Wey-yi and linux-wireless...anyone else having problems with
> iwlagn and IBSS?
> 
> On Fri, Mar 04, 2011 at 03:27:22AM +0000, Mathias Burén wrote:
> > Hi,
> >
> > (please cc as not subscribed)
> >
> >
> >
> > I think the crash happens when the phone attempts to get an IP, at
> > least that's what the phone says right after/at the crash. Any ideas?
> >
> >
forwarding to my team to work on it, any additional information you can
provide?

It is in IBSS mode, do you have any information can shared with us on
your phone's model, setup, and ...
if you can load the module with debug=0x43fff and provide the dmesg log,
it will be very helpful

Thanks
Wey


