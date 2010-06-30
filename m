Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36107 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0F3Doo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 23:44:44 -0400
Received: by qwi4 with SMTP id 4so111715qwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 20:44:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikC3saJNwAFhHvSyJNqVF1fGPcVfn-hwGpR5V30@mail.gmail.com>
References: <AANLkTikC3saJNwAFhHvSyJNqVF1fGPcVfn-hwGpR5V30@mail.gmail.com>
From: Jono <koppah@gmail.com>
Date: Wed, 30 Jun 2010 13:44:22 +1000
Message-ID: <AANLkTinTDPyeV2QWWmXskp4504nxPIm1neJdxdLat51p@mail.gmail.com>
Subject: ath5k Register Question
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not sure if this is the right place to ask, but I'm looking for
information on a specific register on Atheros cards.

I've been told that there is a register that Atheros chips update with
information about how much of a set period has been detected as 'CCA'
time. Unfortunately, I cannot find this information in the source
code. The only register I found that matches this even closely appears
to only be used during noise calibration, and not updated
continuously.

Any help would be greatly appreciated!

Thank you,

--
Jonathan Guerin
