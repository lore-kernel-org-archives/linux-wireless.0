Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59461 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbYFDWTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 18:19:21 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K41K9-0002FL-GB
	for linux-wireless@vger.kernel.org; Wed, 04 Jun 2008 22:19:17 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 22:19:17 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 22:19:17 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: hostap now defaults to monitor mode?
Date: Wed, 04 Jun 2008 23:19:08 +0100
Message-ID: <g274cq$2sn$1@ger.gmane.org> (sfid-20080605_001924_745391_A5E4E83C)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On linux-next-20080604 hostap seems to default to monitor mode breaking
scripts that expect it to be in managed mode by default. Has hostap always
defaulted to monitor mode? I can't see a patch in the Ubuntu kernel tree to
change this...

-- 
Sitsofe | http://sucs.org/~sits/

