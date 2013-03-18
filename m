Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:63690 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CRKbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 06:31:49 -0400
Received: by mail-qc0-f177.google.com with SMTP id u28so2674079qcs.36
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 03:31:49 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Mar 2013 11:31:49 +0100
Message-ID: <CANMvdA-YEzYM5PCEC=6bwoiFFejLFYuLYPZHhJLctEUOGHBokA@mail.gmail.com> (sfid-20130318_113158_777056_8D186EAA)
Subject: IW channels list question
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
