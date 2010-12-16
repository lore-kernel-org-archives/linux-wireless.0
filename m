Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:1784 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0LPTIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 14:08:07 -0500
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id oBGJ86TB029674
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:08:06 -0800
Received: from iwn8 (iwn8.prod.google.com [10.241.68.72])
	by kpbe20.cbf.corp.google.com with ESMTP id oBGJ85b9015717
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:08:05 -0800
Received: by iwn8 with SMTP id 8so3900877iwn.20
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 11:08:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101216174410.GB5677@tux>
References: <1292482775.3542.8.camel@jlt3.sipsolutions.net>
	<AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	<1292499024.3612.3.camel@jlt3.sipsolutions.net>
	<AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
	<1292501047.3612.9.camel@jlt3.sipsolutions.net>
	<AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
	<1292502934.3612.15.camel@jlt3.sipsolutions.net>
	<AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
	<1292504020.3612.17.camel@jlt3.sipsolutions.net>
	<AANLkTinWkYK2Zu1LsKw9YQ4dAXJ2b_quEvZLc59-c_5q@mail.gmail.com>
	<20101216174410.GB5677@tux>
Date: Thu, 16 Dec 2010 11:08:04 -0800
Message-ID: <AANLkTimcALT7STVZyfgaWeCCpfCBM-tchZL94=ONLUL3@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Paul Stewart <pstew@google.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 9:44 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Try this:

I'm now on vacation and thousands of miles (and more importantly a few
firewalls) away from my build system.  If you want to know if this
works before the end of the end of the year, you can try to replicate
the conditions (scan active during ieee80211_do_stop()), otherwise we
can go back to this next year.

--
Paul
