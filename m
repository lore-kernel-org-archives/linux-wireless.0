Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60413
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbZLXFIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 00:08:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id 9F52724C140
	for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 21:08:18 -0800 (PST)
Date: Wed, 23 Dec 2009 21:08:18 -0800 (PST)
Message-Id: <20091223.210818.02262058.davem@davemloft.net>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Someone please expediently fix whatever it is that makes the iwlwifi
drivers rebuild every single time I type make.

It's a real intense pain when I have an 'allmodconfig' tree for build
validations, I pull some unrelated changed into the tree, and I see
iwlwifi rebuild no matter what.

This is not sane behavior.

Thanks.
