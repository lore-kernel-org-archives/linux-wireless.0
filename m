Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:46734 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYEQWnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 18:43:01 -0400
Received: by wf-out-1314.google.com with SMTP id 27so743172wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2008 15:43:00 -0700 (PDT)
Message-ID: <69e28c910805171543u27a542b0nf2ab86e5702660e@mail.gmail.com> (sfid-20080518_004310_063315_124C8DF5)
Date: Sun, 18 May 2008 00:43:00 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] b43: Add hooks for firmware debugging
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200805180035.04341.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200805172244.35966.mb@bu3sch.de> <200805172324.13818.mb@bu3sch.de>
	 <69e28c910805171527y4521a9e7n34d1842281234769@mail.gmail.com>
	 <200805180035.04341.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 18, 2008 at 12:35 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Sunday 18 May 2008 00:27:49 Stefanik G=E1bor wrote:
>> On Sat, May 17, 2008 at 11:24 PM, Michael Buesch <mb@bu3sch.de> wrot=
e:
>> Hmm, are we calling this "Broadcom BCM43xx Microcode" instead of
>> "Broadcom AirForce One Microcode" for licensing/trademark reasons? T=
he
>> official name of these cards is AirForce One.
>
> That's the first time I hear that, so it's most likely not _that_ off=
icial. ;)
>
> And quite honestly, I don't care at all playing bullshit-bingo with b=
uzzwords.
> The device has the product number 43XX, so we identify it that way.
>
> --
> Greetings Michael.
>

Another question: is this legal in the US? AFAIK this might conflict
with FCC regulations. (Not sure about EU.)

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
