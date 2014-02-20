Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39523 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaBTMJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 07:09:04 -0500
Received: by mail-wi0-f174.google.com with SMTP id f8so5790857wiw.7
        for <linux-wireless@vger.kernel.org>; Thu, 20 Feb 2014 04:09:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140218105755.GD1741@redhat.com>
References: <20120418203543.GA16000@x61.home> <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home> <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com> <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com> <20130611185120.GA8751@x61.home> <20140218105755.GD1741@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Thu, 20 Feb 2014 12:08:42 +0000
Message-ID: <CAJZjf_yu99H2dNLph8ynWhXwSso-4HStrO9HA66MD5kE5DhRjw@mail.gmail.com> (sfid-20140220_130909_696850_5CC80B51)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	pedrogfrancisco.public@gmail.com
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:57 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Jun 11, 2013 at 08:51:20PM +0200, Tino Keitel wrote:
>> On Mon, Jun 03, 2013 at 16:18:05 +0200, Stanislaw Gruszka wrote:
>>
>> > Could you try this experimental patch?
>>
>> Hi,
>>
>> on top of kernel 3.9.4 (with TuxOnIce patch), iwconfig wlan0 power on
>> now saves more than 1 W on my ThinkPad X61s with iwl4965. I can finally
>> switch to a recent kernel. Thanks a lot.
>
> This patch stuck on mailing list far too long, I'll post it. Even if it
> crash firmware on 3945, power save is disabled by default.

Ok!
The patch was not forgotten, just indefinitely delayed :/
Now that I can compile a kernel in 10 minutes instead of >1h, I'll try
to test it :)
-- 
Pedro
