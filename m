Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53393 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2GIODt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 10:03:49 -0400
Received: by obbuo13 with SMTP id uo13so20574823obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 07:03:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120707185953.GA3911@pandem0nium>
References: <20120706125043.GA23189@pandem0nium>
	<CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com>
	<5244861.J1Tyef1FCX@bentobox>
	<4991617.K7XqcvhjBY@bentobox>
	<CAD2nsn2m1wizCw6WY-k0KRY2NJTaqqxdoA_d_+K-kqrhw+FZ3w@mail.gmail.com>
	<CAD2nsn1-ZrKQxTYc_YZ6ETxovD9o7=Ygd2j2MxJiq8Vsiu19QQ@mail.gmail.com>
	<CAD2nsn2_16KcE2g5gysc5XwVtns5jAwD+doRzqTQdsim8xbchQ@mail.gmail.com>
	<20120707185953.GA3911@pandem0nium>
Date: Mon, 9 Jul 2012 19:33:49 +0530
Message-ID: <CAD2nsn31Y5U2A2vDt_WBb_pGghoXqMZGYW5+DFFT+TPwsv-pcw@mail.gmail.com> (sfid-20120709_160353_879985_C313B5C6)
Subject: Re: ath9k: Problems with diversity on AR9330
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Sven Eckelmann <sven@narfation.org>, ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Simon,

> we had this checked out before, the EEPROM/EEP_ANT_DIV_CTL1 value is set to 000000c9,
> so bit 6 and 7 are on (as checked in this function).
>

this seems to match with the value AR9485. I am bit involved with some
other task which i need to finish
by some time. I will definitely get back to this once i am done with
that. Obviously i need to lot more
analysis and test in a shielded environment to get a grasp of this.
Further i can only ensure it in
AR9485.


-- 
thanks,
shafi
