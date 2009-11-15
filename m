Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:57619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZKOHLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 02:11:42 -0500
Received: by fg-out-1718.google.com with SMTP id e12so1987316fga.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Nov 2009 23:11:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911140958m138c92dat60a62607a08616b2@mail.gmail.com>
References: <02a401ca6370$51fa0ff0$f5ee2fd0$@kaist.ac.kr> <43e72e890911120732m74dbe2d4m14dd146cd0fb3016@mail.gmail.com>
	<43e72e890911131226i1a58560haeddca42c76bc1a9@mail.gmail.com>
	<032b01ca64f9$f520c400$df624c00$@kaist.ac.kr> <43e72e890911140958m138c92dat60a62607a08616b2@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 15 Nov 2009 08:11:27 +0100
Message-ID: <69e28c910911142311t593a21beq8312ec99c430d6d3@mail.gmail.com>
Subject: Re: ath9k: Unknown symbol
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jinsung Lee <ljs@netsys.kaist.ac.kr>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 14, 2009 at 6:58 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Nov 13, 2009 at 11:13 PM, Jinsung Lee <ljs@netsys.kaist.ac.kr> wrote:
>> Dear Luis,
>>
>> I've compiled successfully with compat-wireless-2009-11-13 version.
>> Also, modprobe command has been passed successfully.
>> But, when configuring with "ifconfig", it shows the following kernel message and then totally shut down, resulting in reboot.
>>
>> ==========================================
>> ...
>>
>> <7>[  181.995318] ath: tx chmask: 1, rx chmask: 1
>> <7>[  181.995328] ath: BSS Changed PREAMBLE 0
>> <7>[  181.995335] ath: BSS Changed CTS PROT 0
>> <1>[  181.998952] BUG: unable to handle kernel NULL pointer dereference at 00000004
>
> Are you on 2.6.32? If so try wireless-testing directly, it'll give you
> what you want which is 2.6.32-rcx and the latest wireless drivers.
> There may be a backport issue with 2.6.32 but I cannot tell where it
> is crashing with the trace you pasted without debugging enabled.
>
>  Luis

> <4>[  182.001070] Pid: 2745, comm: phy1 Not tainted (2.6.30-02063009-generic #02063009) M1022E
This says 2.6.30...



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
