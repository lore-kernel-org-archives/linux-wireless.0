Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63529 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LTPYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 10:24:44 -0500
Received: by iaeh11 with SMTP id h11so10401237iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 07:24:44 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <20208.43183.619217.106262@gargle.gargle.HOWL> (sfid-20111220_162452_626626_899F9B3B)
Date: Tue, 20 Dec 2011 20:54:31 +0530
To: =?utf-8?Q?=E6=9D=8E=E5=88=9A?= <gang.li@watchdata.com>
Cc: linux-wireless@vger.kernel.org
Subject: RE: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
In-Reply-To: <20111220052951.0C13C20012@mail.watchdata.com.cn>
References: <20207.19812.522615.450498@gargle.gargle.HOWL>
	<20111220052951.0C13C20012@mail.watchdata.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

李刚 wrote:
> So , is there any way to set the re-transmit times when ACK not received?
> Now , it will send 10 times.

Unfortunately no, it cannot be done. The firmware has to be modified
to allow such changes and the firmware is currently available only in binary form.

Sujith
