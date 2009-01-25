Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:1523 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZAYUed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 15:34:33 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3264333fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 12:34:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200901252105.37604.mb@bu3sch.de>
References: <200901251422.42616.mb@bu3sch.de> <20090125184517.GH22475@tesla>
	 <20090125193656.GI22475@tesla> <200901252105.37604.mb@bu3sch.de>
Date: Sun, 25 Jan 2009 21:34:31 +0100
Message-ID: <69e28c910901251234w7835412y533a183f347c54a2@mail.gmail.com> (sfid-20090125_213517_195225_D6358B46)
Subject: Re: regulatory: Operation already in progress
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 25, 2009 at 9:05 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> I think returning an error doesn't make sense.
> All the set-regulatory nl80211 command does is "set the domain to X". So why does it
> fail, if it was already X before the call. All the caller wants is to select domain X.
> That's what he gets in any case. Whether it was set to X or not before the call shouldn't matter.
> It's also confusing to get a "command failed" from iw.
>

Yes, it's pretty much like printing "FATAL: Unable to print out error
code because no error has occurred" on success.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
