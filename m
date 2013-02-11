Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000Ab3BKRd7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 12:33:59 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1BHXxHj018021
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 12:33:59 -0500
Received: from [10.3.229.60] (vpn-229-60.phx2.redhat.com [10.3.229.60])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r1BHXxd7011769
	for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 12:33:59 -0500
Message-ID: <1360604039.1559.44.camel@dcbw.foobar.com> (sfid-20130211_183403_505976_3359CD0A)
Subject: brcmsmac and IBSS
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 11 Feb 2013 11:33:59 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Had a bug report that a 4313 doesn't support IBSS mode, and dug around
and found out that brcmsmac only supports STA mode.  Is that really true
and there's no IBSS support in the smac driver?  Is that a firmware or
driver limitation?  Seems odd that this got missed during the merge
reviews as IBSS is pretty basic functionality that all the kernel wifi
drivers have had for 5 or 7 years.

Dan

