Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760342Ab3JPKxx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 06:53:53 -0400
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rhyland Klein <rklein@nvidia.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 0/5] rfkill-gpio: ACPI support
Date: Wed, 16 Oct 2013 13:53:38 +0300
Message-Id: <1381920823-15403-1-git-send-email-heikki.krogerus@linux.intel.com> (sfid-20131016_125455_239628_D25933C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The first patches prepare the driver for the support. The last patch
can then add the support quite easily. With these patches, adding DT
support later will be quite straight forward if someone needs it.


Heikki Krogerus (5):
  net: rfkill: gpio: convert to resource managed allocation
  net: rfkill: gpio: clean up clock handling
  net: rfkill: gpio: spinlock-safe GPIO access
  net: rfkill: gpio: prepare for DT and ACPI support
  net: rfkill: gpio: add ACPI support

 net/rfkill/Kconfig       |   2 +-
 net/rfkill/rfkill-gpio.c | 211 ++++++++++++++++++++++-------------------------
 2 files changed, 99 insertions(+), 114 deletions(-)

-- 
1.8.4.rc3

