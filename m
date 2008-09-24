Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:36160 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXQGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 12:06:06 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2122647fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2008 09:06:05 -0700 (PDT)
Message-ID: <1ba2fa240809240906t3263f565r971af9a9defa1639@mail.gmail.com> (sfid-20080924_180611_440085_39DEE62D)
Date: Wed, 24 Sep 2008 19:06:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helmut Schaa" <hschaa@suse.de>
Subject: Re: [RFC v2] basic background scan
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200809241755.15950.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200809241636.38762.hschaa@suse.de>
	 <200809241719.28983.hschaa@suse.de>
	 <1222270421.4257.37.camel@johannes.berg>
	 <200809241755.15950.hschaa@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> SCAN_OFF,
>> SCAN_BG,
>> SCAN_SW,
>> SCAN_HW
>>
>> then you can check for scan >= SCAN_SW
>
> Maybe. Thinking about it.

SCAN_BG is under soft scan so why SCAN_HW is in the same level?
Conceptually this is wrong
Tomas
