Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45496 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaHSHWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 03:22:33 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so9475975pab.12
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 00:22:33 -0700 (PDT)
Message-ID: <53F2FB31.3090802@linaro.org> (sfid-20140819_092247_904179_56562F81)
Date: Tue, 19 Aug 2014 08:22:25 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
To: ath6kl@lists.infradead.org, Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: ath6kl DT support and multiple instances.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I noticed that ath6kl partially supports Device trees, via 
check_device_tree() function in init.c.

I have a use case for adding reset line and pinctrl properties to this 
dt bindings, but soon realized that this function would not work for 
multiple instances of the driver, as there is no direct 
association/binding of dt node and driver instance.

Just wondering if this is a know limitation and there will be no 
possible multiple instances of this driver?

is check_device_tree function obsolete?

should I care about multiple instances?

Other than adding static code in the board file, are there any other 
options to pass platform data like reset gpio lines and pinctrl 
properties to the driver?


thanks,
srini
