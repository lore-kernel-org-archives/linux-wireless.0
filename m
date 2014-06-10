Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:54020 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaFJWJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 18:09:35 -0400
Received: by mail-la0-f42.google.com with SMTP id el20so4391124lab.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 15:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 10 Jun 2014 15:09:13 -0700
Message-ID: <CAB=NE6VZs7d2bJNW0cp7NhPUMKr=bHn+pKwhvtk2U71rno4VMA@mail.gmail.com> (sfid-20140611_000939_047950_CB44C794)
Subject: Re: [RFC 1/2] crda: simplify text parsing for country/rules
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 12:25 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Remove strange parsers.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Did you test this with the different types of accepted rules?

  Luis
