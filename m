Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55937 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab2AXUHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 15:07:11 -0500
Received: by eekc14 with SMTP id c14so2305508eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 12:07:10 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k get's completely knocked out by rt3572 device
Date: Tue, 24 Jan 2012 21:07:06 +0100
Message-ID: <13411135.eH6opTgxBo@helmutmobil.site> (sfid-20120124_210716_460695_7A0C3000)
In-Reply-To: <4F1EF618.6080108@01019freenet.de>
References: <4F1EF618.6080108@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 24. Januar 2012, 19:19:04 schrieb Andreas Hartmann:
> - At the moment of stopping netperf on rt3572, the ath9k device
> instantly started sending / receiving data again as expected.
[...]
> Does anybody has an idea what could cause this situation? Or is this normal?

Your netperf traffic is in the direction STA -> AP or also in the other
direction?

Helmut
