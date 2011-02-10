Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1BJIkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 03:40:25 -0500
From: "Ferraton, Jean RegisX" <jean.regisx.ferraton@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "marcel@holtmann.org" <marcel@holtmann.org>
Date: Thu, 10 Feb 2011 08:40:03 +0000
Subject: Advise on how to integrate latest bluetooth updates on linux 2.6.35
 kernel
Message-ID: <6E42A1B4DD2F7B4D80A1F26BB498BF9F8C9F56AFD4@irsmsx501.ger.corp.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm working in the bluetooth part in a project based on the 2.6.35 linux kernel.

We've found some bugs related to bluetooth, and I've seen that most of these bugs have been solved by latest releases (2.6.36 and 2.6.37).

To implement these modifications, I have the following options:

1- Implement all the patches one by one
2- Use the bluetooth modules (*.ko) included in the latest compat-wireless release
3- Overwrite the bluetooth source files in the kernel with the ones coming from compat-wireless  and rebuild

In my opinion, the 2nd solution seems the cleaner and easier way to achieve this. Could you advise me about the best way to proceed?
Thanks

Regards

Jean Régis Ferraton
CVE/CWS team
Jean.RegisX.Ferraton@intel.com

Intel France
134, av Eisenhower
BP 73586
31023 TOULOUSE cedex 1

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

