Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40610 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaJ0XnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 19:43:16 -0400
Received: by mail-lb0-f169.google.com with SMTP id l4so1585851lbv.28
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2014 16:43:14 -0700 (PDT)
Message-ID: <544ED890.1070605@gmail.com> (sfid-20141028_004319_762650_D4D2D9EC)
Date: Tue, 28 Oct 2014 00:43:12 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Lennart Poettering <mztabzr@0pointer.de>
CC: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Manager <networkmanager-list@gnome.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Kernel module(r8712u) reload - suspend/resume - systemd
References: <544ECAAA.5090204@gmail.com> <20141027231512.GF17084@gardel-login>
In-Reply-To: <20141027231512.GF17084@gardel-login>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.10.2014 00:15, Lennart Poettering wrote:
> On Mon, 27.10.14 23:43, poma (pomidorabelisima@gmail.com) wrote:
> 
>> but is there a better way to do it?
> 
> This appears to be a kernel driver bug. Please report this issue
> against the kernel driver in question, systemd is not the right place
> to work around that.
> 
> Lennart
> 

It's not a bug, it's a feature, just as true for the systemd. :)
Given the condition of the entire Linux Wireless LAN stack this can go actually.


poma

