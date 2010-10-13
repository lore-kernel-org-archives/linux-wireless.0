Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51647 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0JMCm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 22:42:26 -0400
From: "Zheng, Jiajia" <jiajia.zheng@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wifi-test-devel@lists.sourceforge.net"
	<wifi-test-devel@lists.sourceforge.net>,
	Paul Stewart <pstew@google.com>
Date: Wed, 13 Oct 2010 10:42:00 +0800
Subject: RE: [PATCH] wifi-test: add simple roam test script
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF227D8A52F2@shsmsx502.ccr.corp.intel.com>
References: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Luis R. Rodriguez wrote:
> This adds a simple roam test script. It uses the supplicant
> wpa_cli utility to interact with your existing session.
> You can either use Network Manager and connect to an ESS
> or use wpa_supplicant manually and connect to an ESS, in
> both cases you need to hand pick an ESS by SSID and support
> the control interface of the supplicant. The script will just
> force a roam onto all the APs on the ESS in round robin,
> sleeping 2 seconds between each roam. If you are not testing
> signal drops you can use this to move around APs without
> walking around a building.
> 
> Cc: Paul Stewart <pstew@google.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---

The patch has been applied to wifi-test. Thank you for adding this roam test. 

bests, 
jiajia
