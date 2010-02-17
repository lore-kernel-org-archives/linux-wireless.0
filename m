Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55886 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190Ab0BQJAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 04:00:43 -0500
Received: by bwz19 with SMTP id 19so5266009bwz.28
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 01:00:41 -0800 (PST)
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] nl80211: add power save commands
References: <20100216201026.25148.40799.stgit@tikku>
	<201002170835.00109.holgerschurig@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 17 Feb 2010 11:00:38 +0200
In-Reply-To: <201002170835.00109.holgerschurig@gmail.com> (Holger Schurig's message of "Wed\, 17 Feb 2010 08\:34\:59 +0100")
Message-ID: <87k4ucgrt5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <holgerschurig@gmail.com> writes:

>> The only missing command from nl80211, which Wireless Extensions had,
>
> "iwconfig XXX modulation" ?

Heh, I didn't even know about that command. I'll add "usable command"
to the commit log :)

-- 
Kalle Valo
