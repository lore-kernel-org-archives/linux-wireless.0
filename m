Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34317 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1LDCva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 21:51:30 -0500
Received: by vbbfc26 with SMTP id fc26so3172622vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2011 18:51:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHW5WCJhwGSM74nN5ivoEgP98y_hbbOB8yDO9+2ahhy2B4H7yw@mail.gmail.com>
References: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
	<4EC7E739.4080404@broadcom.com>
	<CAHW5WCLUefvgvRkgz7Nr+Rwu6_96t7EVVB33U0ED5g9a0cHFXw@mail.gmail.com>
	<CAHW5WCK7SU8CJRM8pLy9omEtrPu0_ES=SxWfYEWt30NCwBGEZw@mail.gmail.com>
	<CAHW5WCJhwGSM74nN5ivoEgP98y_hbbOB8yDO9+2ahhy2B4H7yw@mail.gmail.com>
Date: Sun, 4 Dec 2011 10:51:29 +0800
Message-ID: <CAJ-VmonP9thpmYHrEe=3TZ5yfr_C_JgV0Cum8+ONQJ=-aq6JRQ@mail.gmail.com> (sfid-20111204_035139_486263_D5456B82)
Subject: Re: Wireless stalled after a few minutes with Linux Kernel 3.1
From: Adrian Chadd <adrian@freebsd.org>
To: Haohui Liao <liaohaohui@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I can't help with this, except to say "if you can bisect the
compat-wireless source until you find the offending commit, it can be
fixed".

I'd suggest creating a kernel.org bugzilla report, but it seems
bugzilla is still down.




adrian
