Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3626 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYEPRu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 13:50:57 -0400
Date: Fri, 16 May 2008 13:27:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Martin Dubuc <martind1111@gmail.com>
Cc: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Monitor mode on boot
Message-ID: <20080516172738.GB9880@tuxdriver.com> (sfid-20080516_195059_372322_570219A1)
References: <7a0107ba0805151404o778a09ddj522fffa3edbeec6@mail.gmail.com> <69e28c910805160316q7c1b869an7fd554979ea260b8@mail.gmail.com> <7a0107ba0805160627l55f53b04r69a32e1bba36ecb6@mail.gmail.com> <69e28c910805160703j4fef73e8x2c357f91d4b43ea5@mail.gmail.com> <20080516150824.GB6510@tuxdriver.com> <7a0107ba0805160906r4bfcd09ch6e550b929e3bd21d@mail.gmail.com> <69e28c910805160916o68ba2512k3aaab29d592c54ff@mail.gmail.com> <7a0107ba0805160926ib7cc07er57c00054dec238e@mail.gmail.com> <69e28c910805160940x3de182cdrb1d49588ccb392d2@mail.gmail.com> <7a0107ba0805160948j3ca21a85v1b5fce8ddca23ac9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7a0107ba0805160948j3ca21a85v1b5fce8ddca23ac9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 12:48:26PM -0400, Martin Dubuc wrote:
> This would solve the boot up issue, but probably not the case where
> interfaces are added after the system is booted up (USB or PCI cards that
> can be hot plugged).

udev?

-- 
John W. Linville
linville@tuxdriver.com
