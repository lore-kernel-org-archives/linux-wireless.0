Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.mandriva.com ([212.85.150.183]:54030 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbXKGKuD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 05:50:03 -0500
From: Claudio Matsuoka <claudio@mandriva.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: mac80211 doesn't reassociate after failed ProbeResp
Date: Wed, 7 Nov 2007 08:49:52 -0200
Cc: Michael Wu <flamingice.sourmilk.net@polimi.it>,
	Johannes Berg <johannes.sipsolutions.net@polimi.it>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <20071107102158.61b4ca3d@morte>
In-Reply-To: <20071107102158.61b4ca3d@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711070849.53931.claudio@mandriva.com> (sfid-20071107_105010_004457_1779E3BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 November 2007 07:21:58 Stefano Brivio wrote:

> then, instead of trying to reassociate, mac80211 acts like this:
> Nov  7 02:06:25 morte [123785.138041] wlan0: dropped data frame to not
> associated station 00:14:c1:35:8d:eb Nov  7 02:06:25 morte [123785.138243]

I confirm this problem with the b43, and also rtl8187 (which sometimes 
reassociates spontaneously, sometimes not).
