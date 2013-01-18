Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41982 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3ARRU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 12:20:29 -0500
Received: by mail-ea0-f169.google.com with SMTP id d13so1611609eaa.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2013 09:20:28 -0800 (PST)
Message-ID: <50F9845A.4030106@gmail.com> (sfid-20130118_182033_095325_C71A46EB)
Date: Fri, 18 Jan 2013 18:20:26 +0100
From: Natanji <natanji@gmail.com>
MIME-Version: 1.0
To: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Problems with weak signal on 2.4/5 GHz dual band routers
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
hope this is the right place to ask for support on a very specific
problem I'm experiencing. Otherwise I'd be happy to know where else I
should report this problem.

So my university is running a dual band eduroam wifi. When the signal is
rather weak, I get frequent timeouts for my network connections (even
though my network manager will report that I am still connected). When I
force my wifi card to stay on the 2.4 GHz network, everything works
fine. But I usually want to use 5GHz and benefit from the higher
transmission rate, so toggling that manually is just an ugly workaround.

Seemingly the driver makes it connect to the 5 GHz band, even if the
signal quality is so bad there that the transmission rate is worse
and/or the connection breaks down frequently (because naturally, 5 GHz
networks have more signal loss over distance). I have no idea how
iwlwifi and wpa_supplicant work internally, so maybe I am missing some
vital option there?

My card is an Intel 6300 Ultimate AGN, and I've tried different network
managers (currently on wicd) but get the same problem everywhere.

Cheers,
Natanji
