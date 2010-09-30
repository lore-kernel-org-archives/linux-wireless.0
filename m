Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:56388 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab0I3Lue (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 07:50:34 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o8UBoVvV005953
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 14:50:31 +0300
Subject: Re: [PATCH 2/2] wl1271: Move work-init calls to hw allocation
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1285846632.11177.163.camel@wimaxnb.nmp.nokia.com>
References: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1285846632.11177.163.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 14:45:03 +0300
Message-ID: <1285847103.17497.11.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2010-09-30 at 13:37 +0200, Juuso Oikarinen wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Due to legacy reason, dating back to when the wl1251 and wl1271 still were
> a unified driver, some work-structures are initialized on hardware startup.
> 
> The hardware recovery code creates a scenario in which it is possible for a
> workstruct to be re-initialized while the work-function itself is running,
> which causes a kernel WARNing and a subsequent reboot.
> 
> To remedy this, move the work initialization calls to the hw allocation,
> which is the logically correct place for them anyway.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>

-Tuomas

