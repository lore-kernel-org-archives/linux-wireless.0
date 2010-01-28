Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48955 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab0A1Pha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 10:37:30 -0500
Received: by pwi21 with SMTP id 21so550163pwi.21
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2010 07:37:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001281528.37342.holgerschurig@gmail.com>
References: <8bf247761001280439u59a9b6ch1128d42a83116594@mail.gmail.com>
	 <8bf247761001280607i2b90f73j96e3afd02fb6da29@mail.gmail.com>
	 <201001281528.37342.holgerschurig@gmail.com>
Date: Thu, 28 Jan 2010 21:07:29 +0530
Message-ID: <8bf247761001280737v135c8fbfj7a5e1b7eea881d5c@mail.gmail.com>
Subject: Re: scan does not work
From: Sriram V <vshrirama@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

How do i check if the communication between the host and libertas is proper?

Is there any way i can do it?


Sometimes, i find that the loading of firmware fails with -110
(timeout) return value. what i do is rmmod the driver and do a insmod
again and it works!.

Regards,
sriram

On Thu, Jan 28, 2010 at 7:58 PM, Holger Schurig <holgerschurig@gmail.com> wrote:
>> libertas cmd: DNLD_CMD: command 0x0006, seq 9, size 63
>
> That is the scan command.
>
>> libertas cmd: CMD_RESP: response 0x8006, seq 9, size 11
>
> And that the scan response. As I can see from the size (11
> bytes), it doesn't contain any results. The same happens with
> the other scan-responses:
>
>> libertas cmd: CMD_RESP: response 0x8006, seq 10, size 11
>> libertas cmd: CMD_RESP: response 0x8006, seq 11, size 11
>> libertas cmd: CMD_RESP: response 0x8006, seq 12, size 11
>> libertas cmd: CMD_RESP: response 0x8006, seq 13, size 11
>> libertas cmd: CMD_RESP: response 0x8006, seq 14, size 11
>
> I'd suggest you check your antenna.
>
> --
> http://www.holgerschurig.de
>
