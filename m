Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40047 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbZKKPaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 10:30:15 -0500
Date: Wed, 11 Nov 2009 10:22:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Zheng, Jeff" <jeff.zheng@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"wifi-test-devel@lists.sourceforge.net"
	<wifi-test-devel@lists.sourceforge.net>
Subject: Re: [ANNOUNCE] wifi-test 1.0 released
Message-ID: <20091111152214.GG4392@tuxdriver.com>
References: <154E55ADF9629D4E8D13F08BF92ABEB63FDC983366@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <154E55ADF9629D4E8D13F08BF92ABEB63FDC983366@PDSMSX501.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 10:59:27PM +0800, Zheng, Jeff wrote:
> All,
> 
> The wifi-test project is raised by Intel with a goal to deliver test suites
> to opensource community that validates linux wireless drivers. wifi-test
> 1.0 covers following wireless features:
> + BSS: BSS association, fragmentation/RTS/CTS, BSS channels etc
> + IBSS: IBSS association, IBSS fragmentation/RTS/CTS, IBSS channels.
> + Security: WEP (BSS/IBSS), WPA/WPA2, 802.1X.
> + Power management: S3/S4, RFKILL
> + Performance: upload/download speed for different combinations.
> + Others: Wext mode, nl80211 mode
> + 802.11 a/b/g/n: Above features in a/b/g/n band.
> 
> You can download wifi-test 1.0 from:
> http://intellinuxwireless.org/testing/Download/wifi-test-1.0.tar.gz
> or through git tree:
> http://www.intellinuxwireless.org/repos/wifi-test.git
> 
> For more information, please see
> http://intellinuxwireless.org/testing/wifi-test.html

Hey, that looks pretty cool...thanks!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
