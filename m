Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:15221 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYFKVrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:47:25 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2048648ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:47:22 -0700 (PDT)
Message-ID: <69e28c910806111446x2793714ftf9ccfe25e9f932f8@mail.gmail.com> (sfid-20080611_234728_677313_7547ECE0)
Date: Wed, 11 Jun 2008 23:46:20 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Broadcom's Hybrid Driver
Cc: "Pavel Roskin" <proski@gnu.org>, "Michael Buesch" <mb@bu3sch.de>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <48504417.7020803@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48500F14.8070300@canonical.com> <200806112047.00854.mb@bu3sch.de>
	 <1213213666.19106.12.camel@dv>
	 <69e28c910806111326j6922905fq1f67201ab4ce298f@mail.gmail.com>
	 <48504417.7020803@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 11:31 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> I have two ideas about what Broadcom is doing.
>
> The b/g device with an ID of 0x4315 and an LP-PHY is the one that HP has
> been shipping in many laptops for the past few months. Perhaps HP wants to
> offer Linux on those computers, but doesn't want to use ndiswrapper for
> wireless access. HP might have enough clout to get Broadcom to budge a
> little on the subject of Linux.
>
> It is also possible that they want to stifle our RE efforts. The license
> accompanying the binary blob states:
>
> "2.6.    No Other Rights Granted; Restrictions.  Apart from the license
> rights expressly set forth in this Agreement, Broadcom does not grant and
> Licensee does not receive any ownership right, title or interest nor any
> security interest or other interest in any intellectual property rights
> relating to the Software, nor in any copy of any part of the foregoing.
>
> Licensee shall not (i) use, license, sell or otherwise distribute the
> Software except as provided in this Agreement, (ii) attempt to reverse
> engineer, decompile or disassemble any portion of the Software; or (iii) use
> the Software or other material in violation of any applicable law or
> regulation, including but not limited to any regulatory agency, such as FCC,
> rules."
>
> Given some of the other parts of the license relating to penalties, etc.,
> anyone trying to RE this code could be in a heap of trouble.
>
> Larry
>

(Resend of previous message with proper CC list. I clicked "Reply"
instead of "Reply to all".)
Hmm... IANAL and I don't live in the US, but AFAIK clean-room
reverse-engineering for the purposes of making documentation and other
non-controversial purposes is allowed, and they can't force you to
forfeit this right of yours. Otherwise a patent holder would have no
way to know if the software in question infringes their patents. I can
also see no copy-protection mechanism attached to the driver, which
prevents DMCA attacks (which could override the right to clean-room
reverse-engineer the software). To me, this text looks like a response
to FCC's robustness requirements. (It's possible that it's only legal
to reverse-engineer this blob if you are outside the US.)

--
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
