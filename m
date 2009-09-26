Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47037 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZIZN70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 09:59:26 -0400
Received: by fxm18 with SMTP id 18so2786433fxm.17
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2009 06:59:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253966835.5122.8.camel@johannes.local>
References: <20090924180048.14503.9579.stgit@tikku>
	 <20090924180251.14503.64152.stgit@tikku>
	 <43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
	 <da94abde0909241210m69bd619sce62645c3aca9aae@mail.gmail.com>
	 <43e72e890909241311j552ee33ata80ba24c386a316b@mail.gmail.com>
	 <da94abde0909251211x347bbd30xdfe2bd05bc1e07e5@mail.gmail.com>
	 <1253966835.5122.8.camel@johannes.local>
Date: Sat, 26 Sep 2009 06:59:29 -0700
Message-ID: <da94abde0909260659g53350ab2gaf58d900489d3b45@mail.gmail.com>
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
	wiphy
From: Kalle Valo <kalle.valo@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 26, 2009 at 5:07 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-09-25 at 12:11 -0700, Kalle Valo wrote:
>
>> I agree. I'm not going to work on adding the driver name right now,
>> but maybe in the future.
>
> $ readlink /sys/class/net/wlan0/phy80211/device/driver/module

Excellent, that shows the driver name easily enough. Thanks.

Kalle
