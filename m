Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53270 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2LUJr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 04:47:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: cashq <cash.q@hotmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath6kl in compat wireless supports AP mode?
References: <7d44469343059cc380b51910982d03fd.squirrel@www.infidigm.net>
	<loom.20121221T014532-248@post.gmane.org>
Date: Fri, 21 Dec 2012 11:47:25 +0200
In-Reply-To: <loom.20121221T014532-248@post.gmane.org> (cashq's message of
	"Fri, 21 Dec 2012 00:50:32 +0000 (UTC)")
Message-ID: <87vcbvu47m.fsf@purkki.adurom.net> (sfid-20121221_104729_561897_E79E2E5D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cashq <cash.q@hotmail.com> writes:

> Thank you so much. It turns out that I took an incorrect version of hostapd-
> 0.7.3. After using hostapd-1.0, AP mode has been successfully enabled.

Thanks for confirming this. I added the requirement to the wiki:

http://wireless.kernel.org/en/users/Drivers/ath6kl

-- 
Kalle Valo
