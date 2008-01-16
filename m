Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29625 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYAPQhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 11:37:19 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Date: Wed, 16 Jan 2008 08:37:10 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003684665@orsmsx416.amr.corp.intel.com> (sfid-20080116_163723_757122_603BA559)
In-Reply-To: <b25c3fa70801152015x482aa4cfle9ed3504f40fd18e@mail.gmail.com>
References: <11998765481610-git-send-email-joonwpark81@gmail.com> <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com> <b25c3fa70801101724he91d934y9db6636c68a32486@mail.gmail.com> <D936D925018D154694D8A362EEB0892003602E2D@orsmsx416.amr.corp.intel.com> <b25c3fa70801101838o7a71cc60h1c8b8a71624aeff9@mail.gmail.com> <478B1EBF.8030701@gmail.com> <478B2E92.5090901@gmail.com> <D936D925018D154694D8A362EEB0892003683D89@orsmsx416.amr.corp.intel.com> <b25c3fa70801152015x482aa4cfle9ed3504f40fd18e@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Joonwoo Park" <joonwpark81@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 15, 2008 8:15 PM, Joonwoo Park  wrote:

> Thank you for your advice, it seems recent base code's commit inserted
> iwl_disable_interrupts() into iwl_pci_probe.
> As like you said, for base code __iwl_disable_interrupts() should
> better than iwl_disable_interrupts for iwl_pci_probe.

I've modified the patch to include this.

> Do you want version of patch for base code?
> Can you ACK for this patch?

Your patch looks good and is currently being tested. 

Thanks!

Reinette
