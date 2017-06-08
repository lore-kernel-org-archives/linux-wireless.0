Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:46223 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751132AbdFHNLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 09:11:34 -0400
From: "Chadzynski, MikolajX" <mikolajx.chadzynski@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "gbhat@marvell.com" <gbhat@marvell.com>,
        "huxm@marvell.com" <huxm@marvell.com>
Subject: porting 'mwifiex: resolve races between async FW init (failure) and
 device removal' to kernel 4.1.x
Date: Thu, 8 Jun 2017 13:11:28 +0000
Message-ID: <382E97DBE488D844B7F3CE8D1D2355C83717C8B6@IRSMSX104.ger.corp.intel.com> (sfid-20170608_151138_332042_E8B635B8)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Races between async firmware initialization and device removal appears on kernel 4.1.x.
Whole scenario leading to the error together with logs is in https://bugzilla.kernel.org/show_bug.cgi?id=196003
Mapping the patch from kernel 4.11.x "mwifiex: resolve races between async FW init (failure) and device removal" solved the problem.
In Bugzilla I've also attached patch which I've tested for pcie interface and it works.
Intel Deutschland GmbH
Registered Address: Am Campeon 10-12, 85579 Neubiberg, Germany
Tel: +49 89 99 8853-0, www.intel.de
Managing Directors: Christin Eisenschmid, Christian Lamprechter
Chairperson of the Supervisory Board: Nicole Lau
Registered Office: Munich
Commercial Register: Amtsgericht Muenchen HRB 186928
