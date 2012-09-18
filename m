Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4326 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab2IRQgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 12:36:52 -0400
Message-ID: <5058A315.6060401@broadcom.com> (sfid-20120918_183716_995363_44FD1D9E)
Date: Tue, 18 Sep 2012 18:36:37 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stanislaw Gruszka" <sgruszka@redhat.com>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rmmod bcma trigger a crash
References: <20120918114830.GA3704@redhat.com>
In-Reply-To: <20120918114830.GA3704@redhat.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2012 01:48 PM, Stanislaw Gruszka wrote:
> Hi
>
> I have following crash when doing rmmod bcma (or
> modprobe -r brcmsmac). It happen on 3.5 and latest
> wireless-testing tree.
>
> <4>Pid: 28372, comm: modprobe Not tainted 2.6.32.sgruszka_03 #7 Hewlett-Packard HP xw8600 Workstation/0A98h

I am doing rmmod of bcma nightly on multiple system. What does 
'2.6.32.sgruszka_03' mean here. Using compat-wireless?

The gdb list seems to suggest there is NULL pointer in the list of 
cores, but need disassembly to be sure.

Gr. AvS

