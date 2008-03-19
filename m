Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227AbYCSTlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:32 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: iwlwifi: Change of code repository
Date: Wed, 19 Mar 2008 10:17:31 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003F2DCD1@orsmsx416.amr.corp.intel.com> (sfid-20080319_194147_641920_2C00CF6B)
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As you know the iwlwifi driver, used for the Intel(r) Wireless WiFi Link
4965AGN and Intel(r) PRO/Wireless 3945ABG Network Connection adapter,
has been included in the kernel since 2.6.24. In the past an out of tree
driver was maintained with its repository hosted on
http://intellinuxwireless.org to enable users to use the iwlwifi driver
with kernels that do not contain it (2.6.18 to 2.6.23). This is not
necessary now that the driver is in the kernel and development has since
shifted upstream.

Drivers released during out of tree development, as well as the code
repositories used to create them, are still available from
http://intellinuxwireless.org. There is no plan to release any new out
of tree drivers and these repositories will thus not receive any
updates. 

The new code repository, which will be synchronized with upstream as
often as possible, is now hosted at
git://git.kernel.org/pub/scm/linux/kernel/git/rchatre/iwlwifi-2.6.git
(seen via gitweb at
http://git.kernel.org/?p=linux/kernel/git/rchatre/iwlwifi-2.6.git). 

Patches to the iwlwifi driver can be based on either one of the
iwlwifi-2.6.git or wireless-testing.git repositories.

The intellinuxwireless.org website has been updated to reflect these
changes.

Any questions or comments are welcome.

Reinette
