Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47618 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2GZR3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 13:29:51 -0400
Received: by gglu4 with SMTP id u4so2219899ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 10:29:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50117096.8010706@candelatech.com>
References: <50117096.8010706@candelatech.com>
Date: Thu, 26 Jul 2012 10:29:37 -0700
Message-ID: <CAMcMvsjVciPhx_aiYzBg+K5oLVGv=f_2TSZ125TJN_ngk__d9g@mail.gmail.com> (sfid-20120726_192955_612212_1D75915F)
Subject: Re: Any suggestions for programmable attenuators?
From: Paul Stewart <pstew@google.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a few units from eubus (http://www.eubus.net, ATS0760-95).
They're fairly easy to interface to (we're controlling them with a
BeagleBone, but need level shifting because they are 5V devices).  We
don't have a whole lot of seat time with them so far, but we've
validated that they work.


--
Paul

On Thu, Jul 26, 2012 at 9:30 AM, Ben Greear <greearb@candelatech.com> wrote:
> In order to automate testing of throughput v/s distance, I am
> hoping to acquire a programmable attenuator that can be
> scripted and supports at least 3 connectors (for 3x3 NICs).
>
> If anyone has any recommendations please let me know.
>
> Thanks,
> ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
