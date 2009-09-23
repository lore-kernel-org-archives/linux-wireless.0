Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:50368 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbZIWHfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:35:38 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
Date: Wed, 23 Sep 2009 09:34:44 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
References: <200909181849.22302.hs4233@mail.mn-solutions.de> <200909230912.57417.hs4233@mail.mn-solutions.de> <1253690505.4458.29.camel@johannes.local>
In-Reply-To: <1253690505.4458.29.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909230934.44176.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You can monitor nl80211 events for scan completion already, so this
> isn't really an issue. In fact, adding a "last scan" thing would not be
> a good idea since the scan might have been different, only contained a
> subset of channels, etc.

Ah, yes.

-- 
http://www.holgerschurig.de
