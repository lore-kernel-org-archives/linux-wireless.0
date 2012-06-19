Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38418 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2FSWvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 18:51:00 -0400
Received: by lbbgm6 with SMTP id gm6so6407558lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 15:50:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL74qpEwZZF2LrfH1xxYNOxCGPBtT=6UKD99w4hsFr5Hzf8h+Q@mail.gmail.com>
References: <CAL74qpEwZZF2LrfH1xxYNOxCGPBtT=6UKD99w4hsFr5Hzf8h+Q@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Jun 2012 08:50:39 +1000
Message-ID: <CAGRGNgUd_8PvJjgcPk-nCJHA47-SmY7-i1XKDg3C_qNR74OMyQ@mail.gmail.com> (sfid-20120620_005106_387391_88E5F95F)
Subject: Re: turn off scanning
To: =?UTF-8?B?6Km55rqQ?= <zhanyuan.roger@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jun 19, 2012 at 11:30 PM, 詹源 <zhanyuan.roger@gmail.com> wrote:
> I want to modify the 802.11 stack code to turn off sw_scanning in STA.
> It's just a personal purpose because my STA has no need to connect to
> a AP. STA just stays on the operation channel.

What are you trying to achieve?

Scanning is usually controlled by a userspace process. "Disabling" it
as simple as making sure that there are no userspace processes, e.g.
wpa_supplicant, NetworkManager, etc. that might initiate a scan.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
