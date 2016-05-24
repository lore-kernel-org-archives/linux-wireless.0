Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:2048 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbcEXTFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 15:05:10 -0400
Subject: Re: AP statistics
To: "Pukitis, Martins" <martins.pukitis@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <22AF109346512440A803B8D2E69399ECA7AA7E@IRSMSX103.ger.corp.intel.com>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <5744A3B6.6000602@neratec.com> (sfid-20160524_210514_832801_EA7617A2)
Date: Tue, 24 May 2016 20:55:50 +0200
MIME-Version: 1.0
In-Reply-To: <22AF109346512440A803B8D2E69399ECA7AA7E@IRSMSX103.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/24/2016 05:29 PM, Pukitis, Martins wrote:
> Hi.
> Is there cfg80211 API for getting AP statistics (bytes sent/received, packets sent/received/dropped)? I know there is "get_station", but it reads per station statistics. Stations may disconnect, hence you can't just sum together all station statistics to get per AP statistics.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

ethtool -S wlan0
should do the trick

BR
Matthias
