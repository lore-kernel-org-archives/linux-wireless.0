Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50821 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995Ab2BOQqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 11:46:43 -0500
Received: by mail-bk0-f45.google.com with SMTP id e19so1443718bku.18
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 08:46:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6V9Yk1OK0uMU=gyxHKuRmHqYdKi9KBmtz8hYhdcpgrhKQ@mail.gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-7-git-send-email-victorg@ti.com>
	<4F27814A.9060906@sipsolutions.net>
	<CAK80WHZw9PRr_wjazJiPUo1vrCpjgyrSx9ydHwLGoJEp3qNwDA@mail.gmail.com>
	<1328562215.3466.3.camel@jlt3.sipsolutions.net>
	<CAK80WHbESx0xtpp2LujPb2-+DXMCJ3NjC6e8KcHvcbKx2tJ7=A@mail.gmail.com>
	<CAB=NE6V9Yk1OK0uMU=gyxHKuRmHqYdKi9KBmtz8hYhdcpgrhKQ@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:46:34 +0200
Message-ID: <CAK80WHZ-FUb1s7EehV0w1=H-QtRGFkcUTuGbg5E=bJr-7VZwpg@mail.gmail.com> (sfid-20120215_174655_308817_EDE3038A)
Subject: Re: [RFC 6/9] mac80211: add ap channel switch command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 1:04 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> Then you need to ensure that a capability is checked and if this
> capability is required but not available yet in mac80211 DFS cannot be
> started.
>

Good point, I will add this check.


-- 
Thanks,
Victor.
