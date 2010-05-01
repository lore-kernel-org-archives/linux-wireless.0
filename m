Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55757 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0EASn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 14:43:56 -0400
Received: by fxm10 with SMTP id 10so1089137fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 11:43:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005012040.42916.mb@bu3sch.de>
References: <4BDC56D2.5060605@gmail.com> <201005012015.50601.mb@bu3sch.de>
	<4BDC729E.5060202@lwfinger.net> <201005012040.42916.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 1 May 2010 20:43:33 +0200
Message-ID: <AANLkTimV8oZ1k0pgAItFpRDEGWEo4YQAvZZvxvJZEXko@mail.gmail.com>
Subject: Re: [PATCH] ssb: Implement fast powerup delay calculation
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 1, 2010 at 8:40 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Saturday 01 May 2010 20:27:42 Larry Finger wrote:
>> OK, I changed the spec to remove the write.
>
> Uhm, I think the spec was perfecly fine.
>
> --
> Greetings, Michael.
>

Yes. The specs stated "do this during 802.11 core init", the problem
was the patch doing the write during ChipCommon init, much earlier.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
