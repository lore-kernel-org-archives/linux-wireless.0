Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2188 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2FPMOT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 08:14:19 -0400
Message-ID: <4FDC7887.8090907@broadcom.com> (sfid-20120616_141455_696018_C8D07380)
Date: Sat, 16 Jun 2012 14:13:59 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
cc: "Kalle Valo" <kvalo@qca.qualcomm.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1339228530.4539.0.camel@jlt3.sipsolutions.net>
 <4FD3A936.8070600@broadcom.com>
 <1339399952.4520.13.camel@jlt3.sipsolutions.net>
 <4FD60369.80108@qca.qualcomm.com>
 <1339425944.4520.27.camel@jlt3.sipsolutions.net>
 <20120614193104.GD32257@tux>
 <1339748211.4512.6.camel@jlt3.sipsolutions.net>
 <4FDAF096.200@qca.qualcomm.com> <4FDB1740.60707@broadcom.com>
 <4FDB5E52.1020608@qca.qualcomm.com>
 <CAB=NE6X=pO5c_yUqMmqU1jm92WJKqBbYioYm-2S4AYS2JXYRTA@mail.gmail.com>
In-Reply-To: <CAB=NE6X=pO5c_yUqMmqU1jm92WJKqBbYioYm-2S4AYS2JXYRTA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2012 06:53 PM, Luis R. Rodriguez wrote:
> So how about CONFIG_CFG80211_CERTIFICATION_ONUS which can be defined
> as an option for features / options whereby the onus for regulatory
> certification is being accepted by the option enabler? Pretty simple
> and to the point, and would allow for research code but also code
> whereby a bit more work is required on the enabler like DFS
> certification.

English is not my native language so I had to look up the meaning of the
word 'onus'. I guess I am fine with it.

Apart from the naming I addressed that if would be better to have it
device on CONFIG_WLAN instead of CFG80211 as it will be used to enable
802.11 device driver features. Any thoughts on that?

Gr. AvS

