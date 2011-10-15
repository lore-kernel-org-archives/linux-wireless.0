Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55526 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1JOJsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 05:48:22 -0400
Received: by ggnb1 with SMTP id b1so1090274ggn.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 02:48:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN=pzd+8wq4Mw3Ww8jTOYNk-Q2EYOvtdgHPi=RMQqbJvJRZtdw@mail.gmail.com>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<CAJ-Vmomy-LGg=mh5=GqmqWuj7T8b1+oV3oaBSZpf6orJSGPTQg@mail.gmail.com>
	<CAN=pzd+8wq4Mw3Ww8jTOYNk-Q2EYOvtdgHPi=RMQqbJvJRZtdw@mail.gmail.com>
Date: Sat, 15 Oct 2011 17:48:21 +0800
Message-ID: <CAJ-VmonaBUTEKLghg8DJsqUpp6iR-R=pPuejUWwq=ukxt+utzg@mail.gmail.com> (sfid-20111015_114826_990512_BD8EE995)
Subject: Re: Ath9k, single antenna on ar9280
From: Adrian Chadd <adrian@freebsd.org>
To: Stanislav Demakov <s.demakov@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You'll have to ask Felix and others, but I think they're more generic
APIs to support things like AR9285 (and the relevant AR9300/AR9400
series NICs) which implement 1x1 but have "classic" style antenna
diversity.

Also, as I've discovered, you _can_ glue an antenna switch onto the
side of a MIMO NIC. Eg, I have an AR9220 based NIC (2x2:2) which has
three antennas, both the second and third are connected to chain 1 via
an antenna switch.



Adrian
