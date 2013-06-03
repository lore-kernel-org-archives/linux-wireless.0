Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab3FCPCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:02:48 -0400
Message-ID: <1370271765.8227.19.camel@jlt4.sipsolutions.net> (sfid-20130603_170252_053788_C851308D)
Subject: Re: [PATCH] iw: Allow basic rates to be configured when joining mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org
Date: Mon, 03 Jun 2013 17:02:45 +0200
In-Reply-To: <CACcxo+ruNm9+xch42j08dBG9jR28=TX+spgy83oGkQHNSesL7A@mail.gmail.com> (sfid-20130530_202056_070183_BAF5397C)
References: <1368233521-10642-1-git-send-email-ashok@cozybit.com>
	 <CACcxo+ruNm9+xch42j08dBG9jR28=TX+spgy83oGkQHNSesL7A@mail.gmail.com>
	 (sfid-20130530_202056_070183_BAF5397C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-30 at 11:20 -0700, Ashok Nagarajan wrote:
> Hi Johannes,
> 
> I am changing the API for mesh join here as per our recent discussion,
> which is to accept basic-rates only when passed the 'freq' attribute.
> I was wondering what would be an acceptable style in iw to convey this
> to user.
> 
> 1. mesh join <mesh ID> [freq in MHz [HT20|HT40+|HT40-|NOHT]
> [basic-rates <rate in Mbps,rate2,...>]] or
> 2. mesh join <mesh ID> [freq in MHz] [HT20|HT40+|HT40-|NOHT]
> [basic-rates <rate in Mbps,rate2,...>]
> 
> Note the nested brackets in style 1.
> 
> Please let me know what you think.

Honestly? I don't really care. The first might be clearer, but it
doesn't matter all that much to me, I don't use mesh anyway ;-)

johannes

