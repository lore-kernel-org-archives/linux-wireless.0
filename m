Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64949 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbcD0Myp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 08:54:45 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Steve deRosier <derosier@gmail.com>
CC: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Steve deRosier" <steve.derosier@lairdtech.com>
Subject: Re: [PATCH] ath6kl: fix missing uart debug pin for 6004 HW 3.0
Date: Wed, 27 Apr 2016 12:54:37 +0000
Message-ID: <87eg9rw6sy.fsf@kamboji.qca.qualcomm.com> (sfid-20160427_145449_481178_5016D420)
References: <1460765932-12660-1-git-send-email-steve.derosier@lairdtech.com>
In-Reply-To: <1460765932-12660-1-git-send-email-steve.derosier@lairdtech.com>
	(Steve deRosier's message of "Fri, 15 Apr 2016 17:18:52 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> For some reason, the 6004 HW 3.0 definition was missing the value for the
> uarttx_pin (used for firmware debug). This corrects this situation.
>
> Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>

Applied, thanks.

-- 
Kalle Valo