Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZELWEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 18:04:54 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1M405n-00080l-5R
	for linux-wireless@vger.kernel.org; Wed, 13 May 2009 00:04:55 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] crda: v1.1.0
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1M405n-00080l-5R@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Wed, 13 May 2009 00:04:55 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of crda (v1.1.0) is available at:

http://wireless.kernel.org/download/crda/crda-1.1.0.tar.bz2

SHA1 sum: 1ab73f7df83aab511d484b6f8b959a96bd6ab1da

Here is the short log of the changes included in this 
release:

Johannes Berg -  break lines nicer in 64-bit openssl keys
Johannes Berg -  make openssl keys 64-bit safe
Johannes Berg -  make openssl verification safe for multiple keys
