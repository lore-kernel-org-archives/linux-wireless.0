Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:62412 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZBOUpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 15:45:15 -0500
Received: by fxm13 with SMTP id 13so5136734fxm.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 12:45:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234714347.4219.70.camel@johannes.local>
References: <20090213105306.GA18754@jm.kir.nu>
	 <1234522804.4219.13.camel@johannes.local>
	 <20090213111523.GA22438@jm.kir.nu>
	 <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com>
	 <1234714347.4219.70.camel@johannes.local>
Date: Sun, 15 Feb 2009 22:45:12 +0200
Message-ID: <1ba2fa240902151245p3afcca43jef27921ad3db4d99@mail.gmail.com> (sfid-20090215_214520_977220_3E483D24)
Subject: Re: [PATCH] nl80211: Optional IEs into scan request
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 6:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2009-02-15 at 15:09 +0200, Tomas Winkler wrote:
>
>> Status questions
>> What is the version of wpa_supplicant that supports WPS.  Is wext
>> covered with IWEVGENIE?
>> Is it currently working with mac80211 based drivers?
>
> The WPS scanning might be an issue in iwlwifi because afaik the hw_scan
> callback doesn't honour any of the ways to add IEs into probe requests?

Correct I'm aware of it.  Your suggestion to create mac80211/cfg
helper for construction of probe requests for HW scan usage is on the
TODO list...

Tomas
