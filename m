Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46127 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2JBOGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 10:06:03 -0400
Received: by pbbrr4 with SMTP id rr4so8799100pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Oct 2012 07:06:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121002133533.GA19403@pandem0nium>
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
	<1349174009-16496-1-git-send-email-sven@narfation.org>
	<CAJ-VmontNVV4TyRO5kEM30T=OmfEN8YUciJSW=j_0HnbadF4JA@mail.gmail.com>
	<20121002133533.GA19403@pandem0nium>
Date: Tue, 2 Oct 2012 07:06:03 -0700
Message-ID: <CAJ-VmomddCMRxx6Vh_i8AJsqYMUCyguUwFt_PQHpDY7-+Gs88A@mail.gmail.com> (sfid-20121002_160622_140170_CCC13DC5)
Subject: Re: [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Sven Eckelmann <sven@narfation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	lindner_marek@yahoo.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hm, there are still issues on Hornet?

And no, you're not supposed to handle the interrupt per se.. it's a
sign that things got upset and you can't trust anything from that
point forward.

Felix is right, it'd be good to log the register accesses that lead up to this.



Adrian
