Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50594 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2LTI6f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 03:58:35 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Golle <dgolle@allnet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00: rt2800pci: allow to load EEPROM data via firmware API
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
	<1355847743-16659-2-git-send-email-juhosg@openwrt.org>
	<20121218222226.GB4825@localhost.localdomain>
	<50D18A5A.2020505@openwrt.org>
Date: Thu, 20 Dec 2012 10:58:31 +0200
In-Reply-To: <50D18A5A.2020505@openwrt.org> (Gabor Juhos's message of "Wed, 19
	Dec 2012 10:35:22 +0100")
Message-ID: <87d2y5umko.fsf@purkki.adurom.net> (sfid-20121220_095837_575113_AFC87B63)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos <juhosg@openwrt.org> writes:

>> Since we use completion here, why we can not just use normal synchronous
>> version of request_firmware? I heard of request_firmware drawbacks, so
>> this approach can be correct. Just want to know if we do not complicate
>> things not necessarily here.
>
> If the driver is built into the kernel, then the synchronous version
> would fail because user-space is not up during probe time.

Didn't udev/systemd guys finally fix their software? At least I recall
seeing such claims on g+.

-- 
Kalle Valo
