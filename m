Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:10418 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbXLTNcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 08:32:05 -0500
Received: by fk-out-0910.google.com with SMTP id z23so3242163fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2007 05:32:04 -0800 (PST)
Message-ID: <c85cb4470712200532y6d842f48qa883701d09de3613@mail.gmail.com> (sfid-20071220_133210_451493_0CB7977D)
Date: Thu, 20 Dec 2007 15:32:03 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add unified BSS configuration
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Tomas Winkler" <tomasw@gmail.com>
In-Reply-To: <1198109817.16241.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1198109817.16241.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Ron, I think this can replace conf_ht as well, but I'd rather do it in
> an extra patch I think. With the erp replacement this patch is already
> large enough but I wanted to do that here to get rid of all the
> duplicate data storing. This is basically a rework of both your patches
> from October.

excellent.
if no issue will pop up following this RFC conf_ht will gladly follow
erp_ie_changed's foot steps on his way out :-)
