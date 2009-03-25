Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62129 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZCYGoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 02:44:39 -0400
Received: by fxm2 with SMTP id 2so2594726fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 23:44:37 -0700 (PDT)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] Removing CONFIG_WIRELESS_OLD_REGULATORY plan
References: <43e72e890903241230y32a317cfga5f809748c5ab978@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Mar 2009 08:44:34 +0200
In-Reply-To: <43e72e890903241230y32a317cfga5f809748c5ab978@mail.gmail.com> (Luis R. Rodriguez's message of "Tue\, 24 Mar 2009 12\:30\:25 -0700")
Message-ID: <87prg614q5.fsf@litku.valot.fi> (sfid-20090325_074443_497593_6A484B12)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> As a lot of you know we have a new regulatory implementation for Linux
> wireless now [1]. We have kept the old regulatory implementation
> through a Kconfig option, CONFIG_WIRELESS_OLD_REGULATORY.
> Distributions are slowly converging to start setting this to "N" -- as
> of 2.6.28. Distributions are also now shipping wireless-regdb [2] and
> CRDA [3].

Just of curiosity, what's happening with crda in debian? I still don't
see them in debian unstable.

I just found iw version 0.9.9-nogit in unstable, though. So things are
going forward.

-- 
Kalle Valo
