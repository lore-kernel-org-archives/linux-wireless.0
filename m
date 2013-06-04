Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:47962 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab3FDP6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 11:58:10 -0400
Message-ID: <70baec5451fd0a9364c69fb06bdbf54a.squirrel@www.infidigm.net> (sfid-20130604_175813_616022_3F4E433A)
In-Reply-To: <877gienh7k.fsf@kamboji.qca.qualcomm.com>
References: <88f1398e0d87f1c79c5781f07bb7fb20.squirrel@www.infidigm.net>
    <877gienh7k.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 4 Jun 2013 12:35:25 -0400
Subject: Ath6kl feature request - list hw capabilities
From: drwho@infidigm.net
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using "iw list" with ath6k doesn't list any Capabilities like other
drivers do.  Example using "iw list" with ath9k.....

Band 1:
Capabilities: 0x11ee
	HT20/HT40
	SM Power Save disabled
	RX HT20 SGI
	RX HT40 SGI
	TX STBC
	RX STBC 1-stream
	Max AMSDU length: 3839 bytes
	DSSS/CCK HT40
Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
Minimum RX AMPDU time spacing: 8 usec (0x06)
HT TX/RX MCS rate indexes supported: 0-15
Frequencies:

Jon

