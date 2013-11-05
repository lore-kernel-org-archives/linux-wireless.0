Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3KENLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:11:34 -0500
Date: Tue, 5 Nov 2013 14:11:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felipe Balbi <balbi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] wl1251: move power GPIO handling into the driver
Message-ID: <20131105131132.GC30670@amd.pavel.ucw.cz> (sfid-20131105_141153_711667_34733F16)
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1382890469-25286-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382890469-25286-3-git-send-email-sre@debian.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 2013-10-27 17:14:27, Sebastian Reichel wrote:
> Move the power GPIO handling from the board code into
> the driver. This is a dependency for device tree support.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
