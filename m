Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:11991 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbZDAGvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 02:51:32 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Implement fullmac-mode support
Date: Wed, 1 Apr 2009 08:50:30 +0200
Cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
	bcm43xx-dev@lists.berlios.de
References: <200904010101.44380.mb@bu3sch.de>
In-Reply-To: <200904010101.44380.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200904010850.30532.hs4233@mail.mn-solutions.de> (sfid-20090401_085136_954383_481178FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	if (modparam_fullmac)
> +		goto ssb_disable;
> +
...
> +ssb_disable:
>  	ssb_device_disable(dev->dev, 0);
>  	ssb_bus_may_powerdown(dev->dev->bus);
>  }


April April!
