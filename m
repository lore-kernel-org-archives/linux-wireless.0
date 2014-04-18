Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:39633 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaDRNpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 09:45:43 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so1604483wes.11
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2014 06:45:42 -0700 (PDT)
Message-ID: <53512C83.20405@gmail.com> (sfid-20140418_154547_768101_B92AFBD3)
Date: Fri, 18 Apr 2014 16:45:39 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Dmitry Grebennikov <dmitry.ew@gmail.com>, iwl@linux.intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bluetooth support of intel wireless 7260ac adapter
References: <535108A0.8070501@gmail.com>
In-Reply-To: <535108A0.8070501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On 04/18/2014 02:12 PM, Dmitry Grebennikov wrote:
> Hello,
> 
> I bought the intel wireless 7260ac adapter. It has both wifi and bluetooth.
> iwlwifi module and linux-firmware are installed and wifi works perfect, but the bluetooth adapter isn't recognized completely!
> Does iwlwifi provide support for bluetooth on this device?

No - iwlwifi is for the wifi function only.

> Or may be it is provided in linux-bluetooth kernel tree?

right.
One thing you may do is to look at http://www.spinics.net/lists/linux-bluetooth/msg46202.html. I know that the Intel BT maintainer (Tedd Ho-Jeong An) has posted a new firmware that might help you. I know that this firmware hasn't been merged to linux-firmware tree yet.
The right place to ask is linux-bluetooth mailing list.

> Help me, please.
> 
> Thank you!
> Dmitry Grebennikov
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
