Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:49685 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbcACHAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 02:00:50 -0500
Subject: Re: [PATCH 1/3] NFC-mei_phy: Refactoring for mei_nfc_connect()
To: Julian Calaby <julian.calaby@gmail.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <56883849.2080304@users.sourceforge.net>
 <5688390B.3080800@users.sourceforge.net>
 <CAGRGNgWiHKLrHMUySnCpfiF1+C=QV-i4C4KNmziga3-E1CLfKA@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5688C712.3070900@users.sourceforge.net> (sfid-20160103_080111_442389_12639A14)
Date: Sun, 3 Jan 2016 08:00:34 +0100
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWiHKLrHMUySnCpfiF1+C=QV-i4C4KNmziga3-E1CLfKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>         r = 0;
>> -
>> -err:
>> +free_reply:
>>         kfree(reply);
>> +free_cmd:
>>         kfree(cmd);
>> -
> 
> Why are you deleting the two blank lines here?

Can they be unnecessary at this source code place
according to the Linux coding style convention?

Regards,
Markus
