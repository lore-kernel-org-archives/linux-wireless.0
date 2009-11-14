Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43486 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZKNR7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 12:59:07 -0500
Received: by iwn8 with SMTP id 8so3380487iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 14 Nov 2009 09:59:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <032b01ca64f9$f520c400$df624c00$@kaist.ac.kr>
References: <02a401ca6370$51fa0ff0$f5ee2fd0$@kaist.ac.kr> <43e72e890911120732m74dbe2d4m14dd146cd0fb3016@mail.gmail.com>
	<43e72e890911131226i1a58560haeddca42c76bc1a9@mail.gmail.com>
	<032b01ca64f9$f520c400$df624c00$@kaist.ac.kr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 14 Nov 2009 09:58:53 -0800
Message-ID: <43e72e890911140958m138c92dat60a62607a08616b2@mail.gmail.com>
Subject: Re: ath9k: Unknown symbol
To: Jinsung Lee <ljs@netsys.kaist.ac.kr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 11:13 PM, Jinsung Lee <ljs@netsys.kaist.ac.kr> wrote:
> Dear Luis,
>
> I've compiled successfully with compat-wireless-2009-11-13 version.
> Also, modprobe command has been passed successfully.
> But, when configuring with "ifconfig", it shows the following kernel message and then totally shut down, resulting in reboot.
>
> ==========================================
> ...
>
> <7>[  181.995318] ath: tx chmask: 1, rx chmask: 1
> <7>[  181.995328] ath: BSS Changed PREAMBLE 0
> <7>[  181.995335] ath: BSS Changed CTS PROT 0
> <1>[  181.998952] BUG: unable to handle kernel NULL pointer dereference at 00000004

Are you on 2.6.32? If so try wireless-testing directly, it'll give you
what you want which is 2.6.32-rcx and the latest wireless drivers.
There may be a backport issue with 2.6.32 but I cannot tell where it
is crashing with the trace you pasted without debugging enabled.

  Luis
