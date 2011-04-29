Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:51295 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985Ab1D2E02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 00:26:28 -0400
Received: by eya28 with SMTP id 28so1068063eya.7
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 21:26:26 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] wl12xx: consider encryption when configuring
 auto arp template
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303812288-9388-1-git-send-email-eliad@wizery.com>
References: <1303812288-9388-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 07:26:11 +0300
Message-ID: <1304051171.12586.117.camel@cumari> (sfid-20110429_062630_861174_A77BA810)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 13:04 +0300, Eliad Peller wrote:
> When configuring the arp response template, and encryption is enabled,
> we should add some space and set the protected flag bit in the fc.
> 
> In order to track the encryption type, set wl->encryption_type when
> setting an encryption key, and reconfigure the arp response.
> Clear this field on wl1271_join, as keys have to be re-configured
> anyway after a join command.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Just for the record, Eliad just told me that there are still some
problems with auto-arp that need to be debugged, so I'm holding back
this patches for now.

-- 
Cheers,
Luca.

