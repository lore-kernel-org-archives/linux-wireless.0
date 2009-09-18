Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:61991 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZIRUvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 16:51:16 -0400
Received: by bwz6 with SMTP id 6so948934bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 13:51:19 -0700 (PDT)
Subject: Re: regression?  No connection with master-2009-09-16 was fine
 until master-2009-09-14
From: ASIC Felix <ic.felix@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1253232836.23567.4.camel@johannes.local>
References: <1253208348.6601.17.camel@darkslate>
	 <1253230530.23567.1.camel@johannes.local>
	 <1253232319.6914.15.camel@darkslate>
	 <1253232542.23567.3.camel@johannes.local>
	 <1253232836.23567.4.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 13:51:12 -0700
Message-Id: <1253307072.6138.2.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-09-17 at 17:13 -0700, Johannes Berg wrote:
> On Thu, 2009-09-17 at 17:09 -0700, Johannes Berg wrote:
> > On Thu, 2009-09-17 at 17:05 -0700, ASIC Felix wrote:
> > 
> > > > and then describe your setup ... the patch works fine here and Holger
> > > > said it fixed his problem. hidden ssid by any chance?
> > > 
> > > Office network, can see about 50 APs, more 2G than 5G.
> > > 
> > > Main office ssid is available on most 2G channels 11g (no 11n), also on
> > > several 5G channels 11a (no 11n). Lots of other ssids are visible.
> > > WPA2/PSK.
> > 
> > I think wpa is the problem, seeing something like that here too, very
> > odd that it could connect otherwise tho.
> 
> yeah I've got it.
> 
> johannes

yes, fixed with your patch "Re: [PATCH] cfg80211: don't overwrite
privacy setting"

Thanks!
Best regards,
Felix

