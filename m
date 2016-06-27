Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35791 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbcF0Jtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 05:49:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, chunkeey@googlemail.com,
	mark.rutland@arm.com, robh+dt@kernel.org,
	arend.vanspriel@broadcom.com
Subject: Re: [PATCH RFC v3 1/3] Documentation: dt: net: add ath9k wireless device binding
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
	<20160624123430.4097-2-martin.blumenstingl@googlemail.com>
Date: Mon, 27 Jun 2016 12:49:43 +0300
In-Reply-To: <20160624123430.4097-2-martin.blumenstingl@googlemail.com>
	(Martin Blumenstingl's message of "Fri, 24 Jun 2016 14:34:28 +0200")
Message-ID: <874m8fhsg8.fsf@purkki.adurom.net> (sfid-20160627_114952_700908_46499347)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> Add documentation how devicetree can be used to configure ath9k based
> devices.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> changes in v2 -> v3:
> - improved wording of the qca,disable-2ghz and qca,disable-5ghz properties
> - replaced qca,eeprom-name with qca,no-eeprom (the eeprom name is now
>   built automatically within ath9k). The naming was chosen to stay
>   consistent with other drivers (such as davicom-dm9000 and via-velocity)
> - added reference to the mac-address and local-mac-address properties
> - removed invalid device_type property from the example
>
>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 46 ++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

For device tree bindings document changes you should CC the device tree
list:

$ scripts/get_maintainer.pl -f Documentation/devicetree/bindings/net/wireless/
Kalle Valo <kvalo@codeaurora.org> (maintainer:NETWORKING DRIVERS (WIRELESS))
Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
Mark Rutland <mark.rutland@arm.com> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS))
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
linux-kernel@vger.kernel.org (open list)

-- 
Kalle Valo
