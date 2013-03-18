Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:53972 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3CRKlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 06:41:37 -0400
Received: by mail-qc0-f177.google.com with SMTP id u28so2678092qcs.36
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 03:41:37 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Mar 2013 11:41:36 +0100
Message-ID: <CANMvdA8A4Q90f5wHHg4kLYKMJYJR-jgk=WsZDJF=5TxMTYg6wg@mail.gmail.com> (sfid-20130318_114141_245728_1EFCA030)
Subject: Question concerning to iw list channels list
From: Francisco Cuesta <ndarkness@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello iw developers,


I would like to ask a question related to the command iw list. The
channels shown with this command where are they taken from? I mean,
does iw call the drivers' API to see which frequencies it can provide?

I ask this in that if I change the regulatory domain to Japan for
instance, I cannot see the 4.9GHz channels with iw list, does it mean
that the driver doesn't support such a channels or that I maybe have
to modify iw list source in order to make them show up?

Thanks in advance,

REgards,

Francisco
