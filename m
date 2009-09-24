Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40554 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZIXEQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 00:16:09 -0400
Received: by bwz6 with SMTP id 6so1034084bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 21:16:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090924035356.GC2726@tuxdriver.com>
References: <da94abde0909231800v75b05677ka6b8570a73b6055c@mail.gmail.com>
	 <20090924035356.GC2726@tuxdriver.com>
Date: Wed, 23 Sep 2009 21:16:12 -0700
Message-ID: <da94abde0909232116n4ddc8bedxf7033a140a0c6fa0@mail.gmail.com>
Subject: Re: wireless-testing broken
From: Kalle Valo <kalle.valo@iki.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 8:54 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Sep 23, 2009 at 06:00:41PM -0700, Kalle Valo wrote:
>> Hi,
>>
>> I upgraded to latest wireless-testing and noticed that I can't connect
>> anymore with my iwl3945. master-2009-09-16 still works. My syslog has
>> this:
>>
>> Sep 24 03:53:28 tikku kernel: [  719.479190] phy0: device no longer
>> idle - scanning
>> Sep 24 03:53:31 tikku wpa_supplicant[12381]: CTRL-EVENT-SCAN-RESULTS
>> Sep 24 03:53:31 tikku wpa_supplicant[12381]: Trying to associate with
>> 00:03:52:d9:27:10 (SSID='ibahn' freq=2452 MHz)
>
> Kalle,
>
> I know you aren't in a great situation for this, but could you try
> a bisect?  Or, you might just try reverting "iwlwifi: reduce noise
> when skb allocation" as a start...

Sure, I'll start bisecting right now.

Kalle
