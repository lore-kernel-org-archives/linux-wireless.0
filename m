Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:62491 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZATTdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 14:33:13 -0500
Received: by rv-out-0506.google.com with SMTP id k40so3248901rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 11:33:13 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 20 Jan 2009 14:33:13 -0500
Message-ID: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com> (sfid-20090120_203318_535786_39B9CC97)
Subject: Atheros (madwifi/ath5k) virtual STA support
From: Catalin Patulea <cat@vv.carleton.ca>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-wireless,

I'm interested in virtual STA support in madwifi and/or ath5k on an
AR5414 (AR5006XS). Specifically, I want one physical wireless adapter
to act as an infrastructure client on multiple networks. I understand
the network will most likely need to be on the same channel.

This is currently prohibited by the madwifi driver (haven't looked at
ath5k thoroughly). What's the underlying reason for this? Someone on
IRC mentioned powersaving, beacon handling and "other reasons". Can
anyone elaborate?

Secondly, what is the procedure to get hardware documentation from
Atheros? I'm specifically interested in the AR5414 datasheet.

Thanks,

Catalin
