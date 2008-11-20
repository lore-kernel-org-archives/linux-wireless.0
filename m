Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:53776 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYKTMIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 07:08:43 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: sysfs was displaying different values for level and noise than procfs
Date: Thu, 20 Nov 2008 13:08:19 +0100
Cc: Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>
References: <200811151831.26403.arvidjaar@mail.ru> <20081119200856.GH3485@tuxdriver.com> <1227131518.3571.16.camel@dv>
In-Reply-To: <1227131518.3571.16.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811201308.19848.hs4233@mail.mn-solutions.de> (sfid-20081120_130847_237904_C280A2B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As for the procfs interface, it could be deprecated.

Sysfs (at least /sys/class/net/*/wireless) is already deprecated, 
see the help text of WIRELESS_EXT_SYSFS:

-------------------------------------------
defined at net/wireless/Kconfig:64

This option enables the deprecated wireless statistics
                        ^^^^^^^^^^

files in /sys/class/net/*/wireless/. The same information
is available via the ioctls as well.

Say Y if you have programs using it, like old versions of
hal.
-------------------------------------------
