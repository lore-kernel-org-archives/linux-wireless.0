Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab1KCH4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 03:56:48 -0400
Subject: Re: [PATCH] ieee80211: Define cipher suite selector for WPI-SMS4
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1320282954.20617.1.camel@dcbw.foobar.com> (sfid-20111103_021545_085394_28C95151)
References: <20111102213456.GA21460@jouni.qca.qualcomm.com>
	 <1320282954.20617.1.camel@dcbw.foobar.com>
	 (sfid-20111103_021545_085394_28C95151)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 08:56:40 +0100
Message-ID: <1320307000.3950.1.camel@jlt3.sipsolutions.net> (sfid-20111103_085651_590509_D630565A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 20:15 -0500, Dan Williams wrote:
> On Wed, 2011-11-02 at 23:34 +0200, Jouni Malinen wrote:
> > This value is used for WPI-SMS4 in ISO/IEC JTC 1 N 9880.
> 
> Does that mean WAPI at some point? :)

If somebody decides they can publish a supplicant for it, we already
have it in a few drivers that have HW crypto. No SW crypto, so there
won't be generic support.

johannes

