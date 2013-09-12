Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36693 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab3ILBTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 21:19:20 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] ath9k: Fix issue with parsing malformed CFP IE
References: <1378879859-32290-1-git-send-email-sujith@msujith.org>
	<1378879859-32290-2-git-send-email-sujith@msujith.org>
Date: Thu, 12 Sep 2013 04:19:18 +0300
In-Reply-To: <1378879859-32290-2-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Wed, 11 Sep 2013 11:40:58 +0530")
Message-ID: <878uz2u99l.fsf@purkki.adurom.net> (sfid-20130912_031924_276675_965F53AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> [1] : http://msujith.org/ath9k/cfp/Malformed-CF-Param.png

Not that it matters anything, but tshark most likely would have given
you ASCII output of that :)

-- 
Kalle Valo
