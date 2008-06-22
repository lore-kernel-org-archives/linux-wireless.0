Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:41970 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbYFVXJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 19:09:52 -0400
Received: by rv-out-0506.google.com with SMTP id k40so6731333rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 16:09:49 -0700 (PDT)
Message-ID: <1ba2fa240806221609p1b0cd641g2304d0812b61ecb3@mail.gmail.com> (sfid-20080623_010955_629801_A984686E)
Date: Mon, 23 Jun 2008 02:09:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Dan Williams" <dcbw@redhat.com>
Subject: Rfkill on ifconfig up.
Cc: "Abbas, Mohamed" <mohamed.abbas@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Little RF KILL design question from user space perspective.
What should be desired return value of ifconfig up when HW rfkill is
on (radio is off).

rfkill on (radio off)
ifconfig wlan0 up
rfkill off (radio on)

Will it be ok for these sequence to require additional ifconfig up to
make driver to work, providing the first ifconfig up failed?

Thanks
Tomas
