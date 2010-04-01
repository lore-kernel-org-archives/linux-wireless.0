Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38878 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0DAUQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 16:16:45 -0400
Received: by bwz1 with SMTP id 1so1135500bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 13:16:44 -0700 (PDT)
To: Luis Correia <luis.f.correia@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH V2] Remove MCU requests for SoC platforms
References: <t2yefe7343f1004010548tdb2db0a3h9570da736a269352@mail.gmail.com>
	<201004011451.44204.IvDoorn@gmail.com>
	<h2iefe7343f1004010558ze63465bcm5e3bd10e702dea66@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 01 Apr 2010 23:16:39 +0300
In-Reply-To: <h2iefe7343f1004010558ze63465bcm5e3bd10e702dea66@mail.gmail.com> (Luis Correia's message of "Thu\, 1 Apr 2010 13\:58\:02 +0100")
Message-ID: <87bpe3hqs8.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Correia <luis.f.correia@gmail.com> writes:

> The ralink SoC platforms do not have an MCU.

Please add a prefix to the title to specify the component. Something
like this:

rtx2x00: remove MCU requests for SoC platforms

-- 
Kalle Valo
