Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from que11.charter.net ([209.225.8.21]:32953 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934815Ab3FSSB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 14:01:28 -0400
Received: from imp09 ([10.20.200.9]) by mta31.charter.net
          (InterMail vM.8.01.05.02 201-2260-151-103-20110920) with ESMTP
          id <20130619173639.YRMI24708.mta31.charter.net@imp09>
          for <linux-wireless@vger.kernel.org>;
          Wed, 19 Jun 2013 13:36:39 -0400
Date: Wed, 19 Jun 2013 13:36:38 -0400
From: rlwkayaker <rlwkayaker@charter.net>
To: linux-wireless@vger.kernel.org
Subject: Howto remove rfkill from kernel
Message-ID: <20130619133638.3d183a00@compuzoo> (sfid-20130619_200132_693034_E98A3E8A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rfkill "feature" has rendered the internal wireless of my
Averatec 3260 laptop unusable.  It works fine with earlier
kernels without this "feature".  How do I remove the rfkill
"feature" from a custom built kernel?
