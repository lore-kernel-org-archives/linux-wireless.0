Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:42323 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYFKPuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 11:50:39 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2160797fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 08:50:38 -0700 (PDT)
Message-ID: <484FF44A.6070004@gmail.com> (sfid-20080611_175043_786080_2179177C)
Date: Wed, 11 Jun 2008 18:50:34 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net
CC: linux-wireless@vger.kernel.org
Subject: Re: [IWLWIFI] Few questions about its advanced features
References: <200806062259.02955.maximlevitsky@gmail.com>
In-Reply-To: <200806062259.02955.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> Hi,
> 
> I want to know whenever iwlwifi 3945 supports those features:
> (I want to learn wireless a bit, don't think that I want to hack
> into somebody's network... unless its mine)
> 
> * Master mode (turn the card into access point)
> * Monitoring of raw wireless traffic
> * Ability to send raw wireless packets (packet injection)
> 
> 
> Best regards,
> 	Maxim Levitsky


At least it seems that driver does support monitor/injection,
but this doesn't work.

monitor mode seems to show only beacon frames.

I see that the AP mode isn't supported, but driver has some code to 
support it.

My question is, are there plans to add AP mode to iwlwifi?

Best regards,
	Maxim Levitsky
