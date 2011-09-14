Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47674 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1INNrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 09:47:04 -0400
Received: by gyg10 with SMTP id 10so1394898gyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 06:47:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110914132751.GA2485@tuxdriver.com>
References: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
	<20110913173226.GF11772@tuxdriver.com>
	<20110914034922.GA23349@vmraj-lnx.users.atheros.com>
	<20110914132751.GA2485@tuxdriver.com>
Date: Wed, 14 Sep 2011 21:47:03 +0800
Message-ID: <CAJ-Vmok2BBUXxmDVY97VG-By8_Kz3B0RNE9sebkAz+K3EeEgVA@mail.gmail.com> (sfid-20110914_154708_455709_284ABBF0)
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
From: Adrian Chadd <adrian@freebsd.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. and I wonder if there are any similar issues with AR9001/AR9002 series NICs.

I see some reasonably funny behaviour with calibration (under freebsd,
the calibration code is the same as ath9k) where the CRC error rates
for the high MCS rates fluctuate quite a bit.
I haven't bothered chasing it down as I've been busy chasing down TX
interrupt issues.



Adrian
