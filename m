Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40262 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3IITKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 15:10:43 -0400
Message-ID: <522E1D31.2090403@candelatech.com> (sfid-20130909_211051_077109_F514A307)
Date: Mon, 09 Sep 2013 12:10:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Always send management frames at MCS-0??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had a user request that we support always sending management frames
(such as EAPOL) at the lowest rate.  Evidently, other equipment does this,
where as normal-ish supplicant/linux tends to send them at much higher
rates.

Any suggestions on how to go about doing this properly?

Any opinions on whether it's a good idea or not?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

