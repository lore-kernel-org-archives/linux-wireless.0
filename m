Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:20878 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYJYJyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 05:54:32 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1252519fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2008 02:54:30 -0700 (PDT)
Message-ID: <2da21fe50810250254w67d0d485v79ffdb40ed2a3b4b@mail.gmail.com> (sfid-20081025_115440_263361_04EB6881)
Date: Sat, 25 Oct 2008 11:54:30 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: crda packaging
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20081020154315.GL9035@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
	 <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
	 <2da21fe50810201336r29ed4e83g18d57e6d01b97349@mail.gmail.com>
	 <20081020140438.GD9035@tesla>
	 <2da21fe50810201448y6f05770at1d611d5a9ddc7e5b@mail.gmail.com>
	 <43e72e890810201515k79ad4e3cj90643ad853e3acfe@mail.gmail.com>
	 <2da21fe50810201539k74dedcfbwf4d63827e10e6c40@mail.gmail.com>
	 <20081020154315.GL9035@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only a couple of issues now remain in crda:

(1) crda needs <linux/nl80211.h>, thus a kernel source tree is
required to build it.
Solution: ship nl80211.h like iw does.

(2) `make verify` fails to validate the db signature if openssl is
selected instead of gcrypt.

Regards,
Davide
