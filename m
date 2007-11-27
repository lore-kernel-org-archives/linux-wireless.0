Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:1776 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047AbXK0J1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 04:27:54 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1189182ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 01:27:52 -0800 (PST)
Message-ID: <c85cb4470711270127l38837623i85dcb9976f848ed1@mail.gmail.com> (sfid-20071127_092832_659147_F6CE4150)
Date: Tue, 27 Nov 2007 11:27:51 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/15] mac80211: adding 802.11n essential A-MPDU addBA capability
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1196094718.4149.299.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <1196086491335-git-send-email-ron.rindjunsky@intel.com>
	 <1196094718.4149.299.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > As this series of patches only adds HT handling with no aggregations,
> > (A-MPDU aggregations acceptance is not obligatory according to 802.11n
> > draft) we are currently sending back a refusal upon this request.
> >
> > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> Do you have a plan already on how to fill in that TODO? Just curious.

yep, this TODO is in the top of my list now, and i will send it over
as soon as it will start to get a decent shape :)
