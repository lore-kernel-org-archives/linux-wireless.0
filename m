Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59607 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbbLCJDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 04:03:53 -0500
Message-ID: <1449133427.2181.5.camel@sipsolutions.net> (sfid-20151203_100358_865828_0BBA78B5)
Subject: Re: wlan0: set_features() failed (-1); wanted 0x0000000000004008,
 left 0x0000000000004808
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Dec 2015 10:03:47 +0100
In-Reply-To: <CALhHN=pXxEvY4wZcaQ8EL9jNgCy-sC97RwiO7PgaNVfKEO1FGw@mail.gmail.com> (sfid-20151203_090413_916734_C3AB3C9F)
References: <87bna8f1si.fsf@kamboji.qca.qualcomm.com>
	 <CALhHN=pXxEvY4wZcaQ8EL9jNgCy-sC97RwiO7PgaNVfKEO1FGw@mail.gmail.com>
	 (sfid-20151203_090413_916734_C3AB3C9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-03 at 09:03 +0100, Janusz Dziedzic wrote:
> 
> Missing:
> net: fix feature changes on devices without ndo_set_features ?
> 

According to the *code* that's there, but maybe Kalle hasn't recompiled
it to the latest tree quite right?

johannes
