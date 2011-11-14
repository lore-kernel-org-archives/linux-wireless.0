Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55529 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1KNQBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 11:01:35 -0500
Received: by vws1 with SMTP id 1so5171955vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 08:01:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADxqDgFoO63RG67McnxUJSmxZ9ZPPnE7obKkn+MZAsoJ4UMQtg@mail.gmail.com>
References: <CADxqDgFoO63RG67McnxUJSmxZ9ZPPnE7obKkn+MZAsoJ4UMQtg@mail.gmail.com>
Date: Mon, 14 Nov 2011 08:01:34 -0800
Message-ID: <CAJ-Vmon3T-boUkWywfj9oQJYg2fF=rGOLyWXanniEGexV9QPJQ@mail.gmail.com> (sfid-20111114_170139_269443_1BCC854A)
Subject: Re: force AR5212 to sleep
From: Adrian Chadd <adrian@freebsd.org>
To: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hm, have you looked to see whether you're then touching any of the
registers you shouldn't touch?
Ie, some parts of the chip are now asleep, so you may not be able to
do things like calibration whilst it's asleep.


Adrian
