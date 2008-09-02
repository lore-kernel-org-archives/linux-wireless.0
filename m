Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:1647 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYIBW26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 18:28:58 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2514244wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 15:28:57 -0700 (PDT)
Message-ID: <40f31dec0809021528x73ce5243p4578fb0f88fb9a0f@mail.gmail.com> (sfid-20080903_002912_213774_AEE819EF)
Date: Wed, 3 Sep 2008 01:28:57 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bugme-new] [Bug 11483] New: Raw socket tx/rx program for "ath0" shows "sending: : No buffer space available"
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	bugme-daemon@bugzilla.kernel.org, karthikg@deccantechnosoft.com
In-Reply-To: <20080902194114.GD3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <bug-11483-10286@http.bugzilla.kernel.org/>
	 <20080902122938.f3858d6d.akpm@linux-foundation.org>
	 <20080902194114.GD3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/2 John W. Linville <linville@tuxdriver.com>:
> On Tue, Sep 02, 2008 at 12:29:38PM -0700, Andrew Morton wrote:
>>
>> (switched to email.  Please respond via emailed reply-to-all, not via the
>> bugzilla web interface).
>>
>> I assume this is an atheros driver problem, not a core networking
>> problem..
>
> ath_pci -- looks like madwifi to me...
>

> wifi1: transmit timed out

MadWiFi indeed, normaly ath5k would handle this card (AR5213 + RF5112A
without 2Ghz part) but ath5k isn't loaded.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
