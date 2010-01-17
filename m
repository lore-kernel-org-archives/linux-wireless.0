Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:5214 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0AQQpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 11:45:04 -0500
Received: by fg-out-1718.google.com with SMTP id 22so292020fge.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 08:45:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001171741.02945.mb@bu3sch.de>
References: <op.u6oef6cl9lhzdc@linux-g0th.site> <69e28c911001170837u4ea715ddn4a8e2001f6c1acc3@mail.gmail.com>
	<201001171741.02945.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 17 Jan 2010 17:44:42 +0100
Message-ID: <69e28c911001170844m2dd5beb9j6ebca9292f41f7ce@mail.gmail.com>
Subject: Re: [PATCH 2/7] b43: N-PHY: implement TX PHY cleanup and setup
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 17, 2010 at 5:41 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Sunday 17 January 2010 17:37:29 Gábor Stefanik wrote:
>> While you are at it, why aren't you programming these table writes?
>> The table handling functions are AFAIK already in place...
>
> Because we like small patches.
> Please do _not_ increase the patchsize.

They do not increase patch size - table reads/writes are one-line (in
fact, they are shorter than the placeholder comments in place of
them).

>
> --
> Greetings, Michael.
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
