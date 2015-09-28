Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38048 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934035AbbI1QIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 12:08:02 -0400
Received: by igxx6 with SMTP id x6so53469046igx.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2015 09:08:01 -0700 (PDT)
Date: Mon, 28 Sep 2015 11:07:41 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Karl =?utf-8?Q?M=C3=B6ller?= <karl@excors.net>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for
 South Africa (ZA) on 5GHz
Message-ID: <20150928160741.GA25936@ubuntu-hedt> (sfid-20150928_180808_082909_647A8C66)
References: <9BEBB87E-EA6D-4219-ADC5-40C1E19DA5DA@excors.net>
 <1443426260.2401.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1443426260.2401.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2015 at 09:44:20AM +0200, Johannes Berg wrote:
> 
> > The bands don’t quite match up and DFS/TPC is (apparently) not 
> > required for 5470 - 5725. More importantly, the max transmitted power
> > seems to be 1W/30dBm e.i.r.p and not 27dBm.
> 
> Without checking now, just a note: we sometimes have lower limits here
> due to spectral power density, indoor/outdoor or TPC requirements.

One of the documents says that the TPC requirement for that range was
lifted in March 2015, so if it was lowered for TPC then we may be able
to bump it up to 30 dBm.

Seth
