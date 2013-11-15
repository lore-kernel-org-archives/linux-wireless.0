Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44306 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3KOO3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 09:29:51 -0500
Received: by mail-lb0-f181.google.com with SMTP id q8so1556501lbi.26
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 06:29:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52862D32.3010601@rempel-privat.de>
References: <39E4555519E9C54593B1BE31E24CB79A39B12884@nasanexd02a.na.qualcomm.com>
 <20131115134752.GQ9795@pogo> <52862D32.3010601@rempel-privat.de>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 15 Nov 2013 15:29:29 +0100
Message-ID: <CAB=NE6VNZDT4JLRM=iqzkaKezXaoaXcXuyTHq62=H-axxGVNZg@mail.gmail.com> (sfid-20131115_152954_448123_B4123D91)
Subject: Re: ath9k_htc: Target is unresponsive
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "Proffit, Jerome" <jproffit@qca.qualcomm.com>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Biard, David" <dbiard@qca.qualcomm.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 3:18 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> I do not know which backport include patch for usb interrupt transfer.

Which patch are you referring to? The backports project releases match
the Linux kernel releases, so the backports-3.12 release is based on
linux v3.12, we can check what kernel the patch you are describing got
merged into Linux by doing:

git describe --contains gitsum

where the gitsum is the gitsum of the patch.

  Luis
