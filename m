Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:35432 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0CWHlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 03:41:00 -0400
Subject: Re: [PATCH 2/2] mac80211: Add support for connection quality
 monitoring
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Marcel Holtmann <marcel@holtmann.org>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <1269328436.11714.56.camel@localhost.localdomain>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269327754-995-3-git-send-email-juuso.oikarinen@nokia.com>
	 <1269328436.11714.56.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 09:37:42 +0200
Message-ID: <1269329862.10120.768.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 08:13 +0100, ext Marcel Holtmann wrote:
> Hi Juuso,
> 
> > Add support for the set_cqm_config op. This op function configures the
> > requested connection quality monitor rssi threshold and rssi hysteresis
> > values to the hardware  if the hardware supports
> > IEEE80211_HW_SUPPORTS_CQM.
> > 
> > For unsupporting hardware, currently -EOPNOTSUPP is returned, so the mac80211
> > is currently not doing connection quality monitoring on the host. This could be
> > added later, if needed.
> 
> I think you mean "For unsupported hardware, ..." ;)

I guess you could phrase it like this as well. Do you think this is a
problem, i.e. do you want me to resubmit a fixed patch?

-Juuso

> Regards
> 
> Marcel
> 
> 


