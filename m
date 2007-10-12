Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4526 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787AbXJLNJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 09:09:09 -0400
Date: Fri, 12 Oct 2007 08:51:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: dragoran <drago01@gmail.com>
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [PATCH 2.6.23.RC9] wpa_supplicant didn't work
	w/ wpa_secured hidden AP
Message-ID: <20071012125108.GA6596@tuxdriver.com> (sfid-20071012_140914_986341_6A0BFF8F)
References: <1192040814.12399.4.camel@abhi-desktop> <20071010202422.GN5962@tuxdriver.com> <f6ca9fed0710120216r282bb4b6tbcb063685a993c95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0710120216r282bb4b6tbcb063685a993c95@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 12, 2007 at 11:16:52AM +0200, dragoran wrote:
> The patch seems not to work for me, I tested with 2.6.23-6.fc8 (where
> the patch is included)... played with ap_scan ... disabled hw_scan but
> I was unable to acciotate.

Yeah, it seems like a no-op to me as well.  Does it actually help anyone?

-- 
John W. Linville
linville@tuxdriver.com
