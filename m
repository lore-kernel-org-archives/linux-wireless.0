Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55737 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0CQEtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 00:49:32 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NrlCD-00027T-Lr
	for linux-wireless@vger.kernel.org; Wed, 17 Mar 2010 05:49:29 +0100
Received: from 69-165-147-23.dsl.teksavvy.com ([69.165.147.23])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 05:49:29 +0100
Received: from monnier by 69-165-147-23.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 05:49:29 +0100
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: iwl3945 and power saving
Date: Wed, 17 Mar 2010 00:49:19 -0400
Message-ID: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I finally upgraded from 2.6.30 to 2.6.33 (mostly for TRIM support) on my
laptop and find that power saving doesn't seem to work any more on its
iwl3945 card.

The extra power consumption is quite significant, so I'm considering
compiling my own driver, manually re-enabling the power-saving code.

But before I do that, I'd like to know what is the risk involved (it
seems pretty serious since it warranted removing the feature
altogether, even tho it was runtime-disabled by default anyway).


        Stefan

