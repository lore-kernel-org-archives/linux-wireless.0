Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40579 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab0LQWTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 17:19:25 -0500
Received: by iyi12 with SMTP id 12so743717iyi.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 14:19:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinWma9xFSUe9ShdVWWRYsFtDVcAoacZAg4RMXA+@mail.gmail.com>
References: <1292620126.22230.12.camel@wwguy-ubuntu> <AANLkTinWma9xFSUe9ShdVWWRYsFtDVcAoacZAg4RMXA+@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Fri, 17 Dec 2010 14:19:04 -0800
Message-ID: <AANLkTi=LmzQVzUruEQAjcSOEjy+x3U_9DqF4tLHENAcU@mail.gmail.com>
Subject: Re: new iwlwifi 6030 uCode available
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/17 Rafał Miłecki <zajec5@gmail.com>:
> 2010/12/17 Guy, Wey-Yi <wey-yi.w.guy@intel.com>:
>> Version 17.168.5.1 of uCode for Intel Intel@ 6030 Series Wi-Fi Adapters
>> is now available for download from
>> http://intellinuxwireless.org/?n=Downloads
>
> I want uCode for 5100 to resolve
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214 !
>
> Damn, do you want us to RE Intel's firmware or what? Is that your policy?

Hi Wey-Yi,

I noticed from this bug report that the workaround is to disable
802.11n.  Is it not possible to instead force-stop all queues, restart
the firmware and driver similar to when uCode crashes?  This might
tide Rafal over for a little while.  It looks like he's not planning
to stop trolling every few days despite your giving the same answer
that the issue is out of your control.

Alternatively, Rafal, you might try to implement this type of fix.

Dan
