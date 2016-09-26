Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbcIZIBH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 04:01:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <fishor@gmx.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wifi test automation?
In-Reply-To: <ea8a3e16-53d9-4637-fdcb-e68829a82f06@gmx.net> (Oleksij Rempel's
        message of "Wed, 21 Sep 2016 10:41:39 +0200")
References: <ea8a3e16-53d9-4637-fdcb-e68829a82f06@gmx.net>
Date: Mon, 26 Sep 2016 11:01:03 +0300
Message-ID: <8760pj2ips.fsf@purkki.adurom.net> (sfid-20160926_100114_535058_841E3766)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <fishor@gmx.net> writes:

> What kind of WiFi testomation are you using?
>
> Right now i found some links, do some of this used by WiFi devs?
> http://avocado-framework.github.io/
> https://autotest.github.io/
> https://github.com/Wi-FiTestSuite
> https://wireless.wiki.kernel.org/en/developers/testing/wifi-test

If I had some free time I would like to try out hostap's test framework
with remote hosts. I find it very promising:

http://w1.fi/cgit/hostap/commit/?id=5865186e311b626ad155123f40f837b562ea14ef

-- 
Kalle Valo
