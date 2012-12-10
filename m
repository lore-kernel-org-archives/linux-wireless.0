Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62894 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2LJVNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:13:01 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1779877qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 13:13:00 -0800 (PST)
Message-ID: <50C65059.9000501@lwfinger.net> (sfid-20121210_221306_477966_B552942D)
Date: Mon, 10 Dec 2012 15:12:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alessandro Lannocca <alessandro.lannocca@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 8192cu misbehaviours with RTL8188RU chipset
References: <CAMfPB_wtsXjxFkY6M4cNjxDK678DV4VPjwDRzVOtgrf-4jDL-Q@mail.gmail.com> <50C61570.6040006@lwfinger.net> <CAMfPB_xV4fCK=G12EYKxgEDBYnOEEe45AmTFCBx67pKP4y+aYQ@mail.gmail.com> <CAMfPB_xBUDwmoHy4RiPZiCN7itYTHW9+n9eMj89YRrg-FkZrgQ@mail.gmail.com>
In-Reply-To: <CAMfPB_xBUDwmoHy4RiPZiCN7itYTHW9+n9eMj89YRrg-FkZrgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2012 03:06 PM, Alessandro Lannocca wrote:
> P.S. I also tested a clean tree (no patches) with the same results.

Please post the output of 'modinfo rtl8172cu | grep -v alias'

