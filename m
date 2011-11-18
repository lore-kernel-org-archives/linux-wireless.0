Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37307 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab1KRLzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:55:42 -0500
Received: by fagn18 with SMTP id n18so4169411fag.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321614923.10266.44.camel@jlt3.sipsolutions.net>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1321614110-32392-6-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1321614923.10266.44.camel@jlt3.sipsolutions.net>
Date: Fri, 18 Nov 2011 12:55:40 +0100
Message-ID: <CAA93jw4PjJjGdKoW8TNUEfiQ-Ck-KRBPBLNeXnS4xJdYvDF2Ng@mail.gmail.com> (sfid-20111118_125559_056317_34841AFD)
Subject: Re: [PATCHv3 2/2] iw: add support for NoAck per tid
From: Dave Taht <dave.taht@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anything that makes it more possible to drop packets when appropriate
makes me happy.

Would there be some way to do this on a per packet basis,
rather than on a per queue basis?

For example, via some sort of dscp map (EF = OK to DROP),
or setsockopt option...
or cgroup...




-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
FR Tel: 0638645374
http://www.bufferbloat.net
