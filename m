Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaAXPDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 10:03:08 -0500
Message-ID: <1390575784.4257.45.camel@jlt4.sipsolutions.net> (sfid-20140124_160312_579304_C16D9FE9)
Subject: Re: [PATCH v3] iw: add VHT MCS/NSS set support to set bitrates
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Fri, 24 Jan 2014 16:03:04 +0100
In-Reply-To: <1386333259-5847-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131206_133435_481375_5CCEDEC1)
References: <1386333259-5847-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131206_133435_481375_5CCEDEC1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-12-06 at 13:34 +0100, Janusz Dziedzic wrote:
> mcs-2.4/mcs-5 rename to ht-mcs-2.4/ht-mcs-5
> vht-mcs-2.4/vht-mcs-5 added
> 
> Format for vht-mcs-*, eg:
> 1:0-9 - set NSS=1 and MCS0-9
> 2:4,5 - set NSS=2 and MCS4, MCS5
> 3:1   - set NSS=3 and MCS1

Applied.

johannes

