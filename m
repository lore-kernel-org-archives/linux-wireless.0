Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1188 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab3BHKUz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 05:20:55 -0500
Message-ID: <5114D178.10007@broadcom.com> (sfid-20130208_112258_499751_D2CD4D0E)
Date: Fri, 8 Feb 2013 11:20:40 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "sl reddy" <slreddyforneobux@gmail.com>
cc: "Onteddu Slreddy" <slreddy88@gmail.com>,
	netdev <netdev@vger.kernel.org>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, wil6210@qca.qualcomm.com,
	brcm80211-dev-list@broadcom.com,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: Wifi basics documents
References: <CAHT=_ri0JBrbPfWJrzjYR4eNDDW9ygMkJSDU4vJXEfh_STLK9g@mail.gmail.com>
 <5114B881.9000100@broadcom.com>
 <CAGmqTTSovcse3k4kv5o=+K6adAb672O5nJ=nXfZmc=d36gMSJw@mail.gmail.com>
In-Reply-To: <CAGmqTTSovcse3k4kv5o=+K6adAb672O5nJ=nXfZmc=d36gMSJw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2013 10:53 AM, sl reddy wrote:
> any successions will be helpful for me

My *suggestion* would be:

http://wireless.kernel.org/en/developers/Documentation

For what it is worth, below is some terrible ascii art.

Gr. AvS

Fullmac model:

                 user-space (libnl)
                  |
+----------+      v
| cfg80211 |------o nl80211 api
+----------+
     ^
     |
     v
+----------+
| fullmac  |------o netdev
| driver   |
+----------+

Softmac model:

                 user-space (libnl)
                  |
+----------+      v
| cfg80211 |------o nl80211 api
+----------+
     ^
     |
     v
+----------+
| mac80211 |------o netdev
+----------+
     ^
     |
     v
+----------+
| softmac  |
| driver   |
+----------+


